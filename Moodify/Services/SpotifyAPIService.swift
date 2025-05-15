//
//  SpotifyAPIService.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import Foundation

class SpotifyAPIService {
    static let shared = SpotifyAPIService()

    private init() {}

    func fetchUserProfile(token: String, completion: @escaping (String?, String?, String?) -> Void) {
        guard let url = URL(string: "https://api.spotify.com/v1/me") else {
            completion(nil, nil, nil)
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            guard
                let data = data,
                error == nil,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let id = json["id"] as? String,
                let displayName = json["display_name"] as? String
            else {
                completion(nil, nil, nil)
                return
            }

            let imageURL = (json["images"] as? [[String: Any]])?.first?["url"] as? String
            completion(id, displayName, imageURL)
        }.resume()
    }
    
//    func searchTracks(query: String, token: String, completion: @escaping ([Song]) -> Void) {
//        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//              let url = URL(string: "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track&limit=10") else {
//            completion([])
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            guard let data = data, error == nil else {
//                completion([])
//                return
//            }
//
//            do {
//                let response = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
//                let songs = response.tracks.items.map { track in
//                    Song(
//                        id: track.id,
//                        title: track.name,
//                        artist: track.artists.first?.name ?? "Unknown Artist",
//                        albumName: track.album.name,
//                        albumImageURL: track.album.images.first?.url ?? "",
//                        spotifyURL: track.external_urls["spotify"] ?? ""
//                    )
//                }
//                    completion(songs)
//                } catch {
//                    print("Failed to decode search: \(error)")
//                    completion([])
//                }
//            }.resume()
//        }
}
