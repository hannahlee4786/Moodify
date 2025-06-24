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
        NavigationLink(value: savedTrack) {
            AsyncImage(url: URL(string: self.savedTrack.track.album.images[0].url)) { image in
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
        }
    }
}
