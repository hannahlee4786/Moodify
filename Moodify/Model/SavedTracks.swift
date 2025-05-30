//
//  SavedTracks.swift
//  Moodify
//
//  Created by Hannah Lee on 5/30/25.
//

import Foundation

struct ImageObject: Codable {
    let url: String     // URL of the image
    let height: Int
    let width: Int
}

struct Album: Codable {
    let href: String            // A link to Web API endpoint providing full details of the album
    let id: String              // The Spotify ID for the album
    let images: [ImageObject]   // Array of album cover art images
    let name: String            // Name of album
}

struct SimplifiedArtistObject: Codable {
    let href: String            // A link to Web API endpoint providing full details of the artist
    let name: String            // Name of artist
}

struct Track: Codable {
    let album: Album                        // Album that track is in
    let artists: [SimplifiedArtistObject]   // Array of artists for track
    let id: String
    let name: String                        // Name of Track
}

struct SavedTrackObject: Codable, Identifiable {
    var id: String { track.id }
    let added_at: String
    let track: Track
}

struct SavedTracks: Codable {
    var total: Int
    var items: [SavedTrackObject]
}
