////
////  SpotifySearchResponse.swift
////  Moodify
////
////  Created by Hannah Lee on 5/7/25.
////
//
//// Response structure for the saved tracks
//struct SpotifySavedTracksResponse: Codable {
//    let href: String
//    let limit: Int
//    let next: String?
//    let offset: Int
//    let previous: String?
//    let total: Int
//    let items: [SavedTrackItem]  // List of saved tracks
//    
//    struct SavedTrackItem: Codable {
//        let addedAt: String
//        let track: Track
//        
//        enum CodingKeys: String, CodingKey {
//            case addedAt = "added_at"
//            case track
//        }
//        
//        struct Track: Codable {
//            let album: Album
//            let artists: [Artist]
//            let availableMarkets: [String]
//            let discNumber: Int
//            let durationMs: Int
//            let explicit: Bool
//            let externalIds: ExternalIds
//            let externalUrls: ExternalUrls
//            let href: String
//            let id: String
//            let isPlayable: Bool
//            let name: String
//            let popularity: Int
//            let previewUrl: String?
//            let trackNumber: Int
//            let type: String
//            let uri: String
//            let isLocal: Bool
//            
//            enum CodingKeys: String, CodingKey {
//                case album, artists, externalIds = "external_ids", externalUrls = "external_urls"
//                case availableMarkets = "available_markets"
//                case discNumber = "disc_number"
//                case durationMs = "duration_ms"
//                case explicit, href, id, isPlayable = "is_playable", name, popularity, previewUrl = "preview_url", trackNumber = "track_number", type, uri, isLocal = "is_local"
//            }
//            
//            struct Album: Codable {
//                let albumType: String
//                let totalTracks: Int
//                let availableMarkets: [String]
//                let externalUrls: ExternalUrls
//                let href: String
//                let id: String
//                let images: [Image]
//                let name: String
//                let releaseDate: String
//                let releaseDatePrecision: String
//                let restrictions: Restrictions
//                let type: String
//                let uri: String
//                enum CodingKeys: String, CodingKey {
//                    case albumType = "album_type"
//                    case totalTracks = "total_tracks"
//                    case availableMarkets = "available_markets"
//                    case externalUrls = "external_urls"
//                    case href, id, images, name
//                    case releaseDate = "release_date"
//                    case releaseDatePrecision = "release_date_precision"
//                    case restrictions, type, uri
//                }
//                
//                struct Image: Codable {
//                    let url: String
//                    let height: Int
//                    let width: Int
//                }
//                
//                struct Restrictions: Codable {
//                    let reason: String
//                }
//            }
//            
//            struct Artist: Codable {
//                let externalUrls: ExternalUrls
//                let href: String
//                let id: String
//                let name: String
//                let type: String
//                let uri: String
//            }
//            
//            struct ExternalUrls: Codable {
//                let spotify: String
//            }
//            
//            struct ExternalIds: Codable {
//                let isrc: String
//                let ean: String
//                let upc: String
//            }
//        }
//    }
//}
