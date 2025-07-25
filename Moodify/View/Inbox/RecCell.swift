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
            AsyncImage(url: URL(string: recommendation.song.album.images[0].url)) { image in
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            
            VStack {
                HStack {
                    Text(recommendation.song.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("PingFangMO-Regular", size: 18))
                        .foregroundStyle(Color.black)
                    
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
                            Image("heartfill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .foregroundStyle(Color.pink)
                        } else {
                            Image("heart")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 20)
                                .foregroundStyle(Color.black)
                        }
                    }
                }
                
                Text(recommendation.song.artists[0].name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 16))
                    .foregroundStyle(Color.black)
                
                Text("@\(recommendation.username)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("BradleyHandITCTT-Bold", size: 16))
                    .foregroundStyle(Color.black)
            }
        }
        .padding(12)
        .frame(width: 170)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 2)
        )
        .padding(.horizontal, 10)
        .padding(.top, 10)
    }
}

