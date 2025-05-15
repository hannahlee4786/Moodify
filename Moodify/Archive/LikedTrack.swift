//
//  LikedTrack.swift
//  Moodify
//
//  Created by Hannah Lee on 5/7/25.
//

import Foundation

struct LikedTrack: Codable {
    let id: String
    let name: String
    let artists: [Artist]
    let album: Album
    let externalUrls: ExternalUrls
    let popularity: Int?
    let previewUrl: String?
    let durationMs: Int?
    let trackNumber: Int?
    let isPlayable: Bool
    let isLocal: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, artists, album
        case externalUrls = "external_urls"
        case popularity, previewUrl = "preview_url", durationMs = "duration_ms"
        case trackNumber = "track_number", isPlayable = "is_playable", isLocal = "is_local"
    }
}

struct Artist: Codable {
    let id: String
    let name: String
    let externalUrls: ExternalUrls
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case externalUrls = "external_urls"
    }
}

struct Album: Codable {
    let albumType: String
    let totalTracks: Int
    let availableMarkets: [String]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let releaseDate: String
    let releaseDatePrecision: String
    let restrictions: Restrictions
    let type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case totalTracks = "total_tracks"
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case restrictions, type, uri
    }
    
    struct Restrictions: Codable {
        let reason: String
    }
    
    struct Image: Codable {
        let url: String
        let height: Int
        let width: Int
    }
}

struct ExternalUrls: Codable {
    let spotify: String
}

struct SpotifySavedTracksResponse: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [SavedTrackItem]
}

struct SavedTrackItem: Codable {
    let addedAt: String
    let track: LikedTrack
    
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case track
    }
}
