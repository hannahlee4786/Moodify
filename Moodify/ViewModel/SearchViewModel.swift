//
//  SearchViewModel.swift
//  Moodify
//
//  Created by Hannah Lee on 5/30/25.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchedTracks: [TrackObject] = []
    
    func search(query: String, completion: @escaping (Bool) -> Void) {
        SpotifyAuthManager.spotifyAuthManager.searchTracks(query: query) { success in
            if success {
                DispatchQueue.main.async {
                    self.searchedTracks = SpotifyAuthManager.spotifyAuthManager.searchedTracks ?? []
                    completion(true)
                }
            } else {
                print("Failed to fetch saved tracks.")
                completion(false)
            }
        }
    }
    
    func select() {
        
    }
}
