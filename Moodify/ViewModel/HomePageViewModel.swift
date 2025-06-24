//
//  HomePageViewModel.swift
//  Moodify
//
//  Created by Hannah Lee on 6/20/25.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class HomePageViewModel {
    @Published var friendsPosts: [Post] = []
    
    private let db = Firestore.firestore()
    
    func createFriendsPosts(userId: String) {
        // Iterate through each friend and add all posts to user's friendsPosts (limit: 3 from each friend)
    }
    
    func randomizeFriendsPosts() {
        // Take friendsPosts and randomize the posts
    }
}
