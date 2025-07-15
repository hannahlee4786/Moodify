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
                .font(.custom("BradleyHandITCTT-Bold", size: 30))
                .foregroundStyle(Color.black)
                .padding(.leading, 8)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: items, spacing: 10) {
                ForEach(savedTracksViewModel.tracksForDisplay) { track in
                    SavedTrackCell(savedTrack: track)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 4)
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}
