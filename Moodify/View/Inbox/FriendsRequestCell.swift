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
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 60, height: 60)
                    }
                }
                Text(request.mood)
                    .font(.footnote)
            }
            
            VStack(spacing: 14) {
                Text(request.username)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(request.description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(DateFormatter.postDateFormatter.string(from: request.date))
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            VStack(spacing: 14) {
                Button {
                    showRecommendations = true
                } label: {
                    Image(systemName: "play.square.stack")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color.black)
                }
                .fullScreenCover(isPresented: $showRecommendations) {
                    RecsGrid(request: request)
                }
                
                Button {
                    showSearch = true
                } label: {
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .fullScreenCover(isPresented: $showSearch) {
                    SendRecView(friendUserId: request.userId, friendUsername: request.username, requestMood: request.mood, requestId: request.id ?? "")
                        .environmentObject(userProfileViewModel)
                        .environmentObject(inboxViewModel)
                }
            }
        }
        .padding(14)
        .border(Color.black, width: 2)
        .padding(14)
    }
}
