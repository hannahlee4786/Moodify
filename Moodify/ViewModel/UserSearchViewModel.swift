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

                self.friends = snapshot?.documents.compactMap {
                    try? $0.data(as: Friend.self).id
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
    func addUserAsFriend(userId: String, currentUserId: String, completion: @escaping (Bool) -> Void) {
        // Don't add if already a friend
        if self.friends.contains(userId) {
            print("Failed to add user as a friend. Friend is already added.")
            completion(false)
            return
        }
        
        if userId == currentUserId {
            print("Failed to add user as a friend. Friend is the user.")
            completion(false)
            return
        }
        
        // Add friend for display
        DispatchQueue.main.async {
            self.friends.append(userId)
        }

        // Wrap userId in a friend struct
        let newFriend = Friend(id: userId)
        
        // Add friend to Firebase
        do {
            try db.collection("users")
                .document(currentUserId)
                .collection("friends")
                .addDocument(from: newFriend) { error in
                    if let error = error {
                        print("Error adding friend: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
        } catch {
            print("Encoding error: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    // Remove searched + selected user as a friend
    func removeUserAsFriend(userId: String, currentUserId: String, completion: @escaping (Bool) -> Void) {
        // Check if friend has never been added (early exit)
        if !self.friends.contains(userId) {
            print("Failed to remove user as friend. User was never a friend.")
            return
        }
        
        // Otherwise remove friend
        db.collection("users")
            .document(currentUserId)
            .collection("friends")
            .document(userId)
            .delete { error in
                if let error = error {
                    print("Error removing friend: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }

                // Delete locally and reload
                DispatchQueue.main.async {
                    if let index = self.friends.firstIndex(of: userId) {
                        self.friends.remove(at: index)
                    }
                }
            }
    }
}
