
//  PostGridView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/7/25.
//

import SwiftUI

struct PostGridView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(postsViewModel.posts) { post in
                PostCell(post: post)
                    .environmentObject(userProfileViewModel)
                    .environmentObject(postsViewModel)
            }
        }
    }
}
