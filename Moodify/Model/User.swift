//
//  User.swift
//  Moodify
//
//  Created by Hannah Lee on 5/5/25.
//

import FirebaseFirestore

// Moodify User object
struct User: Decodable, Identifiable {
    @DocumentID var id: String?
    var username: String
    var bio: String
    var aesthetic: String
    var spotifyToken: String
    var profileImageURL: String?
//    var posts: [Post] = []
}


// Spotify User object
struct SpotifyUserImage: Decodable {
    let url: String
}

struct SpotifyUser: Decodable {
    let id: String
    let display_name: String?
    let images: [SpotifyUserImage]
}
