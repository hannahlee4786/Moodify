//
//  SearchedTrackCell.swift
//  Moodify
//
//  Created by Hannah Lee on 5/31/25.
//

import SwiftUI

struct SearchedTrackCell: View {
    let searchedTrack: TrackObject
    var onSelect: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: self.searchedTrack.album.images[0].url)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 60, height: 60)
            .clipped()
            
            VStack {
                Text(searchedTrack.name)
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(searchedTrack.artists[0].name)
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Spacer()
            
            Button {
                onSelect()
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding(.trailing, 20)
        }
        .padding(.leading, 20)
    }
}
