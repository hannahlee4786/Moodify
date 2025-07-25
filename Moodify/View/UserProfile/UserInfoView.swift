//
//  UserInfoView.swift
//  Moodify
//
//  Created by Hannah Lee on 7/14/25.
//

import SwiftUI

struct UserInfoView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @EnvironmentObject var userSearchViewModel: UserSearchViewModel
    
    var body: some View {
        HStack {
            if let user = userProfileViewModel.user {
                VStack {
                    if let urlString = user.profileImageURL, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } placeholder: {
                            Image("profilewhite")
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 100, height: 100)
                        .padding()
                    }
                    Text(user.aesthetic)
                }
                
                VStack {
                    Text(user.username)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("BradleyHandITCTT-Bold", size: 24))
                        .padding(.bottom, 6)
                        .padding(.top, 10)
                        .foregroundStyle(Color.black)
                    
                    Text("\(userSearchViewModel.friends.count) \(userSearchViewModel.friends.count == 1 ? "friend" : "friends")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("PingFangMO-Regular", size: 16))
                        .foregroundStyle(Color.black)
                    
                    Text(user.bio)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("PingFangMO-Regular", size: 14))
                        .foregroundStyle(Color.black)
                    
                    Spacer()
                }
                .padding(.leading, 22)
                .padding(.top, 10)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 2)
        )
        .padding(.horizontal, 20)
    }
}
