//
//  FriendsPostsGrid.swift
//  Moodify
//
//  Created by Hannah Lee on 6/28/25.
//

import SwiftUI

struct FriendsPostsGrid: View {
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    
    var body: some View {
        ForEach(homePageViewModel.friendsPosts) { post in
            FriendsPostsCell(post: post)
        }
    }
}
