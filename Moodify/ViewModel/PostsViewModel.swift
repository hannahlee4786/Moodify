//
//  PostsViewModel.swift
//  Moodify
//
//  Created by Hannah Lee on 5/23/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false

    private let db = Firestore.firestore()
    
    // Loads user's posts from Firestore
    func loadPosts(for userId: String) {
        self.db.collection("users")
            .document(userId)
            .collection("posts")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching posts: \(error)")
                    return
                }

                // Render from newest to oldest post
                self.posts = snapshot?.documents.compactMap { document in
                    try? document.data(as: Post.self)
                }.sorted(by: { $0.date > $1.date }) ?? []

                print("Successfully fetched \(self.posts.count) posts.")
            }
    }
    
    // Saves post user creates
    func savePost(track: TrackObject, caption: String, mood: String, user: User, completion: @escaping (Bool) -> Void) {
        guard let userId = user.id else {
            completion(false)
            return
        }

        let post = Post(
            albumImageUrl: track.album.images[0].url,
            trackName: track.name,
            artistName: track.artists.first?.name ?? "",
            caption: caption,
            mood: mood,
            date: Date()
        )

        do {
            try db.collection("users")
                .document(userId)
                .collection("posts")
                .addDocument(from: post) { error in
                    if let error = error {
                        print("Error adding post: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Successfully added post to [post].")
                        completion(true)
                    }
                }
        } catch {
            print("Encoding error: \(error.localizedDescription)")
            completion(false)
        }
    }

    // Deletes post user selects
    func deletePost(post: Post, userId: String) {
        guard let postId = post.id else {
            print("Post ID is nil.")
            return
        }

        // First delete from Firestore
        db.collection("users")
            .document(userId)
            .collection("posts")
            .document(postId)
            .delete { error in
                if let error = error {
                    print("Error deleting post from Firestore: \(error.localizedDescription)")
                    return
                }

                print("Successfully deleted post from Firestore.")

                // Delete locally and reload
                DispatchQueue.main.async {
                    self.posts.removeAll { $0.id == post.id }
                }
            }
    }

}
