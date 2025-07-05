//
//  Post.swift
//  Moodify
//
//  Created by Hannah Lee on 5/5/25.
//

import FirebaseFirestore

struct Post: Decodable, Identifiable, Encodable {
    @DocumentID var id: String?
    let userId: String
    let userProfilePic: String?
    let username: String
    let albumImageUrl: String
    let trackName: String
    let artistName: String
    let caption: String
    let mood: String
    var date: Date = Date()
}
