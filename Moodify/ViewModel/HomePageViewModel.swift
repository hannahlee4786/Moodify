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
                        .limit(to: 3)
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
}
