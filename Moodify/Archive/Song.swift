//
//  Song.swift
//  Moodify
//
//  Created by Hannah Lee on 5/5/25.
//

import Foundation

struct Song: Identifiable {
    var id: String
    var title: String
    var artist: String
    var albumName: String
    var albumImageURL: String
    var spotifyURL: String
}
