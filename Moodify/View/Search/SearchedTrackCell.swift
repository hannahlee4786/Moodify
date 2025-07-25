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
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 16))
                    .foregroundStyle(Color.black)
                Text(searchedTrack.artists[0].name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 16))
                    .foregroundStyle(Color.black)
            }
            .padding(.leading, 16)
            
            Spacer()
            
            Button {
                onSelect()
            } label: {
                Image("circleadd")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
}
