//
//  SavedTracksView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/28/25.
//

import SwiftUI

struct SavedTracksView: View {
    @EnvironmentObject var savedTracksViewModel: SavedTracksViewModel
    @State private var viewDidLoad = false
    
    let items: [GridItem] = [
        GridItem(.flexible(minimum: 80)),
        GridItem(.flexible(minimum: 80)),
        GridItem(.flexible(minimum: 80))
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Saved Tracks ♡")
                .font(.title)
                .padding(.leading, 20)
                .padding(.top, 40)
                .frame(maxWidth: .infinity, alignment: .leading)
            LazyVGrid(columns: items, spacing: 10) {
                ForEach(savedTracksViewModel.tracksForDisplay) { track in
                    SavedTrackCell(savedTrack: track)
                }
            }
            .padding()
        }
    }
}
