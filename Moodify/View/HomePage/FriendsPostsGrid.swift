//
//  FriendsPostsGrid.swift
//  Moodify
//
//  Created by Hannah Lee on 6/28/25.
//

import SwiftUI

struct FriendsPostsGrid: View {
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        ForEach(homePageViewModel.friendsPosts) { post in
            FriendsPostsCell(post: post, username: userProfileViewModel.user?.username ?? "", profilePic: userProfileViewModel.user?.profileImageURL ?? "")
                .environmentObject(homePageViewModel)
        }
    }
}
