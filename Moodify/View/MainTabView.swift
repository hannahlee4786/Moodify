//
//  MainTabView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @StateObject var postsViewModel = PostsViewModel()
    @StateObject var savedTracksViewModel = SavedTracksViewModel()
    @StateObject var userSearchViewModel = UserSearchViewModel()
    @StateObject var inboxViewModel = InboxViewModel()
    
    // Add state to track when we've loaded user data
    @State private var hasLoadedInitialData = false
    @State private var selectedTab = 0
    @State private var selectedUser: User?

    init() {
        let customColor = UIColor(red: 242/255, green: 223/255, blue: 206/255, alpha: 1.0)
        UITabBar.appearance().backgroundColor = customColor
        UITabBar.appearance().barTintColor = customColor
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomePageView()
                .tabItem {
                    Image("house")
                }
                .environmentObject(userProfileViewModel)
                .environmentObject(inboxViewModel)
                .tag(0)
            
            UserSearchView(selectedUser: $selectedUser)
                .tabItem {
                    Image("search")
                }
                .environmentObject(userSearchViewModel)
                .environmentObject(userProfileViewModel)
                .tag(1)
            
            CreatePostView(selectedTab: $selectedTab)
                .tabItem {
                    Image("addpost")
                }
                .tag(2)
                .environmentObject(userProfileViewModel)
                .environmentObject(postsViewModel)
            
            UserProfileView()
                .tabItem {
                    Image("profile")
                }
                .tag(3)
                .environmentObject(userProfileViewModel)
                .environmentObject(postsViewModel)
                .environmentObject(savedTracksViewModel)
                .environmentObject(userSearchViewModel)
        }
    }
}
