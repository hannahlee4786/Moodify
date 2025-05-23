//
//  UserProfileViewModel.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class UserProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var userPlaylists: Playlists = Playlists(total: 0, items: [])
    @Published var isLoading = false
    
    private let db = Firestore.firestore()
    
    init(user: User? = nil,
         isLoading: Bool = false) {
        self.user = user
        self.isLoading = isLoading
    }
    
    // Create/Update user from Firestore
    func createOrUpdateUser(id: String, username: String, bio: String, aesthetic: String, spotifyToken: String, profileImageURL: String?, completion: @escaping (Bool) -> Void) {
        
        let userPlaylists = SpotifyAuthManager.spotifyAuthManager.playlists
        self.userPlaylists = Playlists(total: userPlaylists?.count ?? 0, items: userPlaylists ?? [])
        
        var data: [String: Any] = [
            "id": id,
            "username": username,
            "bio": bio,
            "aesthetic": aesthetic,
            "spotifyToken": spotifyToken,
        ]
        
        if let imageURL = profileImageURL {
            data["profileImageURL"] = imageURL
        }
        
        db.collection("users").document(id).setData(data, merge: true) { error in
            if let error = error {
                print("Error updating user: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    // Load user profile from Firestore
    func loadUser(with id: String, token: String, completion: @escaping (User?) -> Void) {
        isLoading = true
        print("Loading user with ID: \(id)")
        
        let docRef = db.collection("users").document(id)
        docRef.getDocument { document, error in
            self.isLoading = false
            
            if let error = error as NSError? {
                print("Error getting user: \(error.localizedDescription)")
                completion(nil)
            }
            else {
                if let document = document {
                    do {
                        self.user = try document.data(as: User.self)
                        print("User loaded successful")
                        completion(self.user)
                    }
                    catch {
                        print(error)
                        completion(nil)
                    }
                }
            }
        }
    }
}
    
