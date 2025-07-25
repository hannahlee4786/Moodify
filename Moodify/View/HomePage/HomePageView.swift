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
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    
    @State private var showInbox = false

    var body: some View {
        VStack {
            HStack {
                Image("home")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 56)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)

                Button {
                    showInbox = true
                } label: {
                    Image("inbox")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                        .padding(.trailing, 10)
                }
                .fullScreenCover(isPresented: $showInbox) {
                    InboxView()
                        .environmentObject(userProfileViewModel)
                        .environmentObject(inboxViewModel)
                }
            }
            
            ScrollView {
                FriendsPostsGrid()
                    .environmentObject(homePageViewModel)
                    .environmentObject(userProfileViewModel)
            }
            .onAppear {
                if let userId = userProfileViewModel.user?.id {
                    homePageViewModel.loadFriendsPosts(for: userId)
                }
            }
            .refreshable {
                if let userId = userProfileViewModel.user?.id {
                    homePageViewModel.loadFriendsPosts(for: userId)
                }
            }
        }
        .padding(.horizontal, 10)
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
    }
}
