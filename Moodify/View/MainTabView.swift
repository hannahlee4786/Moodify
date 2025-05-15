//
//  MainTabView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct MainTabView: View {
    // Create a single shared instance of the view model
    @StateObject private var viewModel = UserProfileViewModel()
    @AppStorage("currentUserID") var currentUserID: String?
    @AppStorage("spotifyToken") var spotifyToken: String?
    
    // Add state to track when we've loaded user data
    @State private var hasLoadedInitialData = false

    var body: some View {
        Group {
            if let userId = currentUserID, !userId.isEmpty {
                TabView {
                    PostGridView(viewModel: viewModel, userId: userId)
                        .tabItem {
                            Label("Posts", systemImage: "house.fill")
                        }
                    
                    UserProfileView(viewModel: viewModel, userId: userId)
                        .tabItem {
                            Label("Profile", systemImage: "person.circle")
                        }
                    
                    CreatePostView(viewModel: viewModel)
                        .tabItem {
                            Label("Add", systemImage: "plus.app")
                        }
                }
                .onAppear {
                    // Load user data when the TabView appears, but only once
                    if !hasLoadedInitialData {
                        print("MainTabView: Loading user data for ID: \(userId)")
                        viewModel.loadUser(with: userId, token: spotifyToken)
                        hasLoadedInitialData = true
                    }
                }
            } else {
                // Show a login screen or error message if no user ID is available
                VStack {
                    Text("No user ID found")
                        .font(.title)
                    
                    Text("Please log in to continue")
                        .padding()
                }
            }
        }
    }
}
