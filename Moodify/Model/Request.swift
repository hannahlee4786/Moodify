//
//  Request.swift
//  Moodify
//
//  Created by Hannah Lee on 6/18/25.
//

import FirebaseFirestore

struct Request: Identifiable, Decodable, Encodable {
    @DocumentID var id: String?
    var recommendations: [TrackObject]      // Array of tracks recommended by friends
    var mood: String                        // Allows user to enter their current mood for friends to send recommendations
    var status: Bool                        // Bool to continue getting recommendations or not
}
