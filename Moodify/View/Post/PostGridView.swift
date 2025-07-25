
//  PostGridView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/7/25.
//

import SwiftUI

struct PostGridView: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(postsViewModel.posts) { post in
                PostCell(post: post)
                    .environmentObject(postsViewModel)
                    .environmentObject(homePageViewModel)
                    .environmentObject(userProfileViewModel)
            }
        }
    }
}
