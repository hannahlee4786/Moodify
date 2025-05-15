//
//  Post.swift
//  Moodify
//
//  Created by Hannah Lee on 5/5/25.
//

import Foundation
import SwiftUI

struct Post: Identifiable {
    var id: UUID
    var image: UIImage
    var caption: String
    var imageURL: String?  // URL for Firebase Storage image
    
    // Added for Firestore compatibility
    var createdAt: Date = Date()

    init(id: UUID = UUID(), image: UIImage, caption: String, imageURL: String? = nil) {
        self.id = id
        self.image = image
        self.caption = caption
        self.imageURL = imageURL
    }
    
    // Helper method to convert to Firestore dictionary
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id.uuidString,
            "caption": caption,
            "imageURL": imageURL ?? "",
            "createdAt": Date()
        ]
    }
}
