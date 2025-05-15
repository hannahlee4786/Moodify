////
////  SpotifySearchViewModel.swift
////  Moodify
////
////  Created by Hannah Lee on 5/7/25.
////
//
//import Foundation
//
//class SpotifySearchViewModel: ObservableObject {
//    @Published var query = ""
//    @Published var results: [Song] = []
//    @Published var isLoading = false
//
//    func search() {
//        // Prepare query
//        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//              let url = URL(string: "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track&limit=10") else {
//            print("Invalid URL or query.")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        // Start loading state
//        isLoading = true
//        URLSession.shared.dataTask(with: request) { data, _, error in
//            DispatchQueue.main.async {
//                self.isLoading = false
//            }
//
//            guard let data = data, error == nil else {
//                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//
//            // Parse the response data
//            do {
//                let response = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
//                let songs: [Song] = response.tracks.items.map { track in
//                    Song(
//                        id: track.id,
//                        title: track.name,
//                        artist: track.artists.first?.name ?? "Unknown Artist",
//                        albumName: track.album.name,
//                        albumImageURL: track.album.images.first?.url ?? "",
//                        spotifyURL: track.external_urls["spotify"] ?? ""
//                    )
//                }
//
//                // Update the UI on the main thread
//                DispatchQueue.main.async {
//                    self.results = songs
//                }
//            } catch {
//                print("Failed to decode search response: \(error)")
//            }
//        }.resume()
//    }
//}
