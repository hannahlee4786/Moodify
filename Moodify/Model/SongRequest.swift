//
//  Request.swift
//  Moodify
//
//  Created by Hannah Lee on 6/18/25.
//

import FirebaseFirestore

struct SongRequest: Identifiable, Decodable, Encodable {
    @DocumentID var id: String?
    var recommendations: [SongRecommendation]   // Array of SongRecommendation object
    let userId: String
    let userProfilePic: String?
    let username: String
    let description: String                     // Allows user to enter what type of song they want for friends to send recommendations
    let mood: String                            // 3 emojis on the type of vibe for recommendations to be
    var date: Date = Date()
}

struct SongRecommendation: Identifiable, Decodable, Encodable {
    var id: String = UUID().uuidString
    let username: String            // Username of user that sent recommendation
    let userId: String              // User ID of user that sent recommendation
    let song: TrackObject           // What song was sent as recommendation
}
