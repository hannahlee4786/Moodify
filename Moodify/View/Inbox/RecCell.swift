//
//  RecommendationCell.swift
//  Moodify
//
//  Created by Hannah Lee on 7/11/25.
//

import SwiftUI

struct RecCell: View {
    @State private var isLiked = false
    let recommendation: SongRecommendation
    
    var body: some View {
        VStack(spacing: 14) {
            VStack {
                AsyncImage(url: URL(string: recommendation.song.album.images[0].url)) { image in
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
            }
            
            VStack {
                HStack {
                    Text(recommendation.song.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    // Like feature for later
                    Button {
                        if isLiked {
                            self.isLiked = false
                        } else {
                            self.isLiked = true
                        }
                    } label: {
                        if isLiked {
                            Image(systemName: "heart.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .foregroundStyle(Color.pink)
                        } else {
                            Image(systemName: "heart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .foregroundStyle(Color.black)
                        }
                    }
                    .padding(.trailing, 20)
                }
                
                Text(recommendation.song.artists[0].name)
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("From @\(recommendation.username)")
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 20)
        }
    }
}

