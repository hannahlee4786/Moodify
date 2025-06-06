//
//  SearchTracks.swift
//  Moodify
//
//  Created by Hannah Lee on 5/31/25.
//

import Foundation

struct TrackObject: Codable {
    let album: Album
    let artists: [SimplifiedArtistObject]
    let id: String
    let name: String
}

struct SearchTracks: Codable {
    let total: Int
    let items: [TrackObject]
}

struct SearchResult: Codable {
    let tracks: SearchTracks
}
