//
//  Playlists.swift
//  Moodify
//
//  Created by Hannah Lee on 5/20/25.
//

struct Tracks: Codable {
    let href: String    // A link to the Web API endpoint where full details of the playlist's tracks can be retrieved
    let total: Int      // Number of tracks in the playlist.
}

struct SimplifiedPlaylistObject: Codable {
    let id: String      // Spotify ID for the playlist
    let name: String    // Name of playlist
    let tracks: Tracks  // Details for the tracks
}

struct Playlists: Codable {
    let total: Int      // Total number of playlists
    let items: [SimplifiedPlaylistObject]
}
