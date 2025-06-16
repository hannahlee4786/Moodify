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
    
    // Add state to track when we've loaded user data
    @State private var hasLoadedInitialData = false
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            CreatePostView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Add", systemImage: "plus.app")
                }
                .tag(1)
                .environmentObject(userProfileViewModel)
                .environmentObject(postsViewModel)
            
            UserProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .tag(2)
                .environmentObject(userProfileViewModel)
                .environmentObject(postsViewModel)
                .environmentObject(savedTracksViewModel)
        }
    }
}
