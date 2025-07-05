//
//  HomePageView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/17/25.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @StateObject var homePageViewModel = HomePageViewModel()
    @StateObject var inboxViewModel = InboxViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Home ❀")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                    NavigationLink(destination: InboxView()
                        .environmentObject(userProfileViewModel)) {
                            Image(systemName: "tray.fill")
                                .font(.title2)
                                .padding(.trailing, 20)
                    }
                }
                .padding(.vertical, 10)
                
                ScrollView {
                    FriendsPostsGrid()
                        .environmentObject(homePageViewModel)
                }
                .onAppear {
                    if let userId = userProfileViewModel.user?.id {
                        homePageViewModel.loadFriendsPosts(for: userId)
                    }
                }
            }
        }
    }
}
