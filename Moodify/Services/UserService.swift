//
//  UserService.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import Foundation
import FirebaseFirestore

class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    
    func createOrUpdateUser(id: String, username: String, bio: String, aesthetic: String, spotifyToken: String, profileImageURL: String?, completion: @escaping (Bool) -> Void) {
        var data: [String: Any] = [
            "id": id,
            "username": username,
            "bio": bio,
            "aesthetic": aesthetic,
            "spotifyToken": spotifyToken
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
    
    func fetchUser(byUsername username: String, token: String? = nil, completion: @escaping (User?) -> Void) {
        db.collection("users")
            .whereField("username", isEqualTo: username)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user by username: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print("No user found for username \(username)")
                    completion(nil)
                    return
                }

                let data = document.data()
                let user = User(
                    id: document.documentID,
                    username: data["username"] as? String ?? "Unknown",
                    bio: data["bio"] as? String ?? "",
                    aesthetic: data["aesthetic"] as? String ?? "",
                    spotifyToken: data["spotifyToken"] as? String ?? "",
                    profileImageURL: data["profileImageURL"] as? String,
                    likedTracks: [],
                    posts: []
                )

                completion(user)
            }
    }
    
    func fetchUser(byId id: String, completion: @escaping (User?) -> Void) {
        let docRef = Firestore.firestore().collection("users").document(id)
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user by ID: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = snapshot?.data() else {
                print("No data found for user ID: \(id)")
                completion(nil)
                return
            }

            let user = User(
                id: id,
                username: data["username"] as? String ?? "Unknown",
                bio: data["bio"] as? String ?? "",
                aesthetic: data["aesthetic"] as? String ?? "",
                spotifyToken: data["spotifyToken"] as? String ?? "",
                profileImageURL: data["profileImageURL"] as? String,
                likedTracks: [],
                posts: []
            )

            completion(user)
        }
    }
    
    func updateUserPosts(userId: String, posts: [Post], completion: @escaping (Bool) -> Void) {
        let userRef = db.collection("users").document(userId)

        userRef.updateData([
            "posts": posts.map { post in
                return [
                    "id": post.id.uuidString,
                    "image": post.image.pngData()?.base64EncodedString() ?? "",  // Convert the image to base64 string
                    "caption": post.caption
                ]
            }
        ]) { error in
            if let error = error {
                print("Error updating user posts: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
