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
    
    func loadPosts(for userId: String) {
        self.db.collection("users")
            .document(userId)
            .collection("posts")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching posts: \(error)")
                    return
                }

                self.posts = snapshot?.documents.compactMap { document in
                    try? document.data(as: Post.self)
                } ?? []

                print("Successfully fetched \(self.posts.count) posts.")
            }
    }

    
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
            mood: mood
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

        
    // Later
    func deletePost() {
        
    }
}
