//
//  HomePageView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/17/25.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @StateObject var homePageViewModel = HomePageViewModel()
    
    @State private var showInbox = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Home ❀")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 20)

                    Button {
                        showInbox = true
                    } label: {
                        Image(systemName: "tray.fill")
                            .font(.title2)
                            .padding(.trailing, 20)
                            .foregroundColor(Color(red: 255/255, green: 105/255, blue: 180/255))
                    }
                    .fullScreenCover(isPresented: $showInbox) {
                        InboxView()
                            .environmentObject(userProfileViewModel)
                            .environmentObject(inboxViewModel)
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
