//
//  MainTabView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: UserProfileViewModel
    @AppStorage("currentUserID") var currentUserID: String?
    @AppStorage("spotifyToken") var spotifyToken: String?
    
    // Add state to track when we've loaded user data
    @State private var hasLoadedInitialData = false

    var body: some View {
        TabView {
            HomePageView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
//                    CreatePostView(viewModel: viewModel)
//                        .tabItem {
//                            Label("Add", systemImage: "plus.app")
//                        }
            
            UserProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }

        }
    }
}
