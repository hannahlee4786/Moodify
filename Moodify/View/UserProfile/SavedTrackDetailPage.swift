//
//  SavedTrackDetailPage.swift
//  Moodify
//
//  Created by Hannah Lee on 5/30/25.
//

import SwiftUI

struct SavedTrackDetailPage: View {
    let savedTrack: SavedTrackObject
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                SavedTrackDetailView(url: savedTrack.track.album.images[0].url)
                    .frame(width: 250, height: 250)
                    .navigationTitle("Info")
                    .navigationBarTitleDisplayMode(.inline)
                }
                
            Text("Title: \(savedTrack.track.name)")
            
            Text("Album: \(savedTrack.track.album.name)")
            
            Text("Artist: \(savedTrack.track.artists[0].name)")
        
            Text("Date Saved: \(savedTrack.added_at)")
        }
    }
}
