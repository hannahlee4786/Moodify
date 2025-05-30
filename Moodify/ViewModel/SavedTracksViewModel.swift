//
//  SavedTracksViewModel.swift
//  Moodify
//
//  Created by Hannah Lee on 5/30/25.
//

import Foundation

class SavedTracksViewModel: ObservableObject {
    @Published var tracksForDisplay: [SavedTrackObject] = []
    private var userSavedTracks: [SavedTrackObject] = []
    private var displayTrackIndex: [Int] = []
    
    init() {
        setSavedTracks {
            self.setRandomTracks()
            self.setTracksForDisplay()
        }
    }
    
    func setSavedTracks(completion: @escaping () -> Void) {
        SpotifyAuthManager.spotifyAuthManager.getSavedTracks { success in
            if success {
                DispatchQueue.main.async {
                    self.userSavedTracks = SpotifyAuthManager.spotifyAuthManager.savedTracks ?? []
                    completion()
                }
            } else {
                print("Failed to fetch saved tracks.")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func getRandomTrackIndex() -> Int {
        var randomIdx = Int.random(in: 0..<userSavedTracks.count)
        
        while displayTrackIndex.contains(randomIdx) {
            randomIdx = Int.random(in: 0..<userSavedTracks.count)
        }
        
        return randomIdx
    }
    
    func setRandomTracks() {
        let count = min(userSavedTracks.count, 8)
        
        for _ in 0..<count {
            displayTrackIndex.append(getRandomTrackIndex())
        }
    }
    
    func setTracksForDisplay() {
        tracksForDisplay = displayTrackIndex.map {
            userSavedTracks[$0]
        }
    }
}
