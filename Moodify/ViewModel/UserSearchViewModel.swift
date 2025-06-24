//
//  UserSearchViewModel.swift
//  Moodify
//
//  Created by Hannah Lee on 6/19/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class UserSearchViewModel: ObservableObject {
    @Published var searchResults: [User] = []
    @Published var friends: [String] = []       // Stores user's friends's id's
    
    private let db = Firestore.firestore()
    
    // Loads user's friends
    func loadFriends(userId: String, completion: @escaping (Bool) -> Void) {
        self.db.collection("users")
            .document(userId)
            .collection("friends")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching friends: \(error)")
                    return
                }

                self.friends = snapshot?.documents.compactMap { document in
                    try? document.data(as: String.self)
                } ?? []

                print("Successfully fetched \(self.friends.count) friends.")
            }
    }

    // Searches for other users of application
    func searchUser(username: String, completion: @escaping (Bool) -> Void) {
        let searchUsername = username.lowercased()
        
        db.collection("users")
            .whereField("username", isGreaterThanOrEqualTo: searchUsername)
            .whereField("username", isLessThan: searchUsername + "\u{f8ff}")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error searching users: \(error)")
                    completion(false)
                }

                DispatchQueue.main.async {
                    self.searchResults = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: User.self)
                    } ?? []
                    completion(true)
                }
            }
    }
    
    // Adds searched + selected user as a friend
    func addUserAsFriend(user: User, userId: String, completion: @escaping (Bool) -> Void) {
        guard let userId = user.id else {
            completion(false)
            return
        }

        do {
            try db.collection("users")
                .document(userId)
                .collection("friends")
                .addDocument(from: user.id) { error in
                    if let error = error {
                        print("Error adding friend: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Successfully added friend to [String].")
                        completion(true)
                    }
                }
        } catch {
            print("Encoding error: \(error.localizedDescription)")
            completion(false)
        }
    }
}
