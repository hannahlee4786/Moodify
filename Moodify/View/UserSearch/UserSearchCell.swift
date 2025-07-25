//
//  UserSearchCell.swift
//  Moodify
//
//  Created by Hannah Lee on 6/19/25.
//

import SwiftUI

struct UserSearchCell: View {
    @EnvironmentObject var userSearchViewModel: UserSearchViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    let searchedUser: User

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: self.searchedUser.profileImageURL ?? "")) { image in
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
            
            VStack {
                Text(searchedUser.username)
                    .font(.custom("PingFangMO-Regular", size: 20))
                    .foregroundStyle(Color.black)
                Text(searchedUser.aesthetic)
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Button {
                    userSearchViewModel.addUserAsFriend(userId: searchedUser.id ?? "", currentUserId: userProfileViewModel.user?.id ?? "") { success in
                        if success {
                            print("Successfully added \(searchedUser.username) as a friend!")
                        }
                    }
                } label: {
                    Image("circleadd")
                        .resizable()
                        .frame(width: 36, height: 36)
                }
                .padding(.trailing, 4)
                
                Button {
                    userSearchViewModel.removeUserAsFriend(userId: searchedUser.id ?? "", currentUserId: userProfileViewModel.user?.id ?? "") { success in
                        if success {
                            print("Successfully removed \(searchedUser.username) as a friend!")
                        }
                    }
                } label: {
                    Image("trash")
                        .resizable()
                        .frame(width: 36, height: 36)
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
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

