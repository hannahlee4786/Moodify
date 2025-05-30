//
//  SavedTrackCell.swift
//  Moodify
//
//  Created by Hannah Lee on 5/28/25.
//

import SwiftUI

struct SavedTrackCell: View {
    let savedTrack: SavedTrackObject
    
    var body: some View {
        AsyncImage(url: URL(string: self.savedTrack.track.album.images[0].url)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Color.gray.opacity(0.3)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .frame(height: 160)
        .clipped()
    }
}
