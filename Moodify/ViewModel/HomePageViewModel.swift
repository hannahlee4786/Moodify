//
//  HomePageViewModel.swift
//  Moodify
//
//  Created by Hannah Lee on 6/20/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class HomePageViewModel: ObservableObject {
    @Published var friendsPosts: [Post] = []
    
    private let db = Firestore.firestore()
    
    func loadFriendsPosts(for userId: String) {
        db.collection("users")
            .document(userId)
            .collection("friends")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching friends: \(error)")
                    return
                }

                // Gets all of friends' ids into an array
                let friendIds = snapshot?.documents.compactMap {
                    try? $0.data(as: Friend.self).id
                } ?? []

                let group = DispatchGroup()
                var allPosts: [Post] = []

                for friendId in friendIds {
                    group.enter()
                    self.db.collection("users")
                        .document(friendId)
                        .collection("posts")
                        .order(by: "date", descending: true)
                        .limit(to: 10)
                        .getDocuments { postSnapshot, error in
                            defer {
                                group.leave()
                            }

                            if let error = error {
                                print("Error fetching posts for \(friendId): \(error)")
                                return
                            }

                            let posts = postSnapshot?.documents.compactMap {
                                try? $0.data(as: Post.self)
                            } ?? []

                            allPosts.append(contentsOf: posts)
                        }
                }

                group.notify(queue: .main) {
                    self.friendsPosts = allPosts.sorted(by: { $0.date > $1.date })
                    print("Successfully fetched \(self.friendsPosts.count) friends' posts.")
                }
            }
    }
    
    // Add like to post
    func like(post: Post, username: String) {
        // Check if user already liked
        if post.likedUsers.contains(username) {
            return
        }

        // Add user to likedUsers array
        var updatedPost = post
        updatedPost.likedUsers.append(username)
        
        // Save the updated likes array to Firestore
        db.collection("users")
            .document(post.userId)
            .collection("posts")
            .document(post.id ?? "")
            .updateData(["likedUsers": updatedPost.likedUsers]) { error in
                if let error = error {
                    print("Error updating likes: \(error.localizedDescription)")
            } else {
                print("Successfully updated likes for post.")
                // Update UI
                if let index = self.friendsPosts.firstIndex(where: { $0.id == post.id }) {
                    DispatchQueue.main.async {
                        self.friendsPosts[index] = updatedPost
                    }
                }
            }
        }
    }
    
    // Remove like from post
    func unlike(post: Post, username: String) {
        // Check if user already unliked
        if !post.likedUsers.contains(username) {
            return
        }

        // Remove user from likedUsers array
        var updatedPost = post
        if let index = updatedPost.likedUsers.firstIndex(of: username) {
            updatedPost.likedUsers.remove(at: index)
        }
        
        // Save the updated likes array to Firestore
        db.collection("users")
            .document(post.userId)
            .collection("posts")
            .document(post.id ?? "")
            .updateData(["likedUsers": updatedPost.likedUsers]) { error in
                if let error = error {
                    print("Error updating likes: \(error.localizedDescription)")
            } else {
                print("Successfully updated likes for post.")
                // Update UI
                if let index = self.friendsPosts.firstIndex(where: { $0.id == post.id }) {
                    DispatchQueue.main.async {
                        self.friendsPosts[index] = updatedPost
                    }
                }
            }
        }
    }
    
    // Loads comments for a post
    func loadComments(for post: Post, completion: @escaping ([Comment]) -> Void) {
        guard let postId = post.id else {
            print("Post ID is nil.")
            completion([])
            return
        }

        db.collection("users")
            .document(post.userId)
            .collection("posts")
            .document(postId)
            .collection("comments")
            .order(by: "username") // Optional: order however you like
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching comments: \(error.localizedDescription)")
                    completion([])
                    return
                }

                let comments = snapshot?.documents.compactMap {
                    try? $0.data(as: Comment.self)
                } ?? []
                
                completion(comments)
            }
    }

    // Allows users to add comments to post
    func addComment(post: Post, username: String, profilePic: String?, comment: String) {
        guard let postId = post.id else {
            print("post.id is nil. Comment not saved.")
            return
        }

        let newComment = Comment(userProfilePic: profilePic, username: username, text: comment)

        do {
            try db.collection("users")
                .document(post.userId)
                .collection("posts")
                .document(postId)
                .collection("comments")
                .addDocument(from: newComment) { error in
                    if let error = error {
                        print("Error adding comment: \(error.localizedDescription)")
                    } else {
                        print("Successfully added comment.")
                    }
                }
        } catch {
            print("Encoding error: \(error.localizedDescription)")
        }
    }
}
