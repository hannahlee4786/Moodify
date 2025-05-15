//
//  User.swift
//  Moodify
//
//  Created by Hannah Lee on 5/5/25.
//

import Foundation

struct User {
    var id: String
    var username: String
    var bio: String
    var aesthetic: String
    var spotifyToken: String
    var profileImageURL: String?
    var likedTracks: [LikedTrack]
    var posts: [Post]
}
