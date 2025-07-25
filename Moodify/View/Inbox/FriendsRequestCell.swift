//
//  FriendsRequestCell.swift
//  Moodify
//
//  Created by Hannah Lee on 6/18/25.
//

import SwiftUI

struct FriendsRequestCell: View {
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    
    @State private var showRecommendations = false
    @State private var showSearch = false
    let request: SongRequest
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 8) {
                if let imageUrl = request.userProfilePic,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                    } placeholder: {
                        Image("profilewhite")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                    }
                }
                Text(request.mood)
                    .font(.footnote)
            }
            
            VStack(spacing: 14) {
                Text("@\(request.username)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("BradleyHandITCTT-Bold", size: 24))
                    .foregroundStyle(Color.black)
                Text(request.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 18))
                    .foregroundStyle(Color.black)
                Text(DateFormatter.postDateFormatter.string(from: request.date))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 12))
                    .foregroundStyle(Color.black)
            }
            .padding(.leading, 10)
                        
            VStack(spacing: 14) {
                Button {
                    showRecommendations = true
                } label: {
                    Image("playlists")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .fullScreenCover(isPresented: $showRecommendations) {
                    RecsGrid(request: request)
                }
                
                Button {
                    showSearch = true
                } label: {
                    Image("plane")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .fullScreenCover(isPresented: $showSearch) {
                    SendRecView(friendUserId: request.userId, friendUsername: request.username, requestMood: request.mood, requestId: request.id ?? "")
                        .environmentObject(userProfileViewModel)
                        .environmentObject(inboxViewModel)
                }
            }
            .frame(alignment: .trailing)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}
