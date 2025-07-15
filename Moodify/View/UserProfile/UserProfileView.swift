//
//  UserProfileView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var savedTracksViewModel: SavedTracksViewModel
    @EnvironmentObject var userSearchViewModel: UserSearchViewModel

    @State private var showEditProfile = false

    var body: some View {
        VStack {
            HStack {
                Image("profileheader")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 56)
                Spacer()
                Button {
                    showEditProfile = true
                } label: {
                    Image("edit")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                }
            }
            .padding(.horizontal)

            ScrollView {
                VStack(spacing: 12) {
                    UserInfoView()
                        .environmentObject(userProfileViewModel)
                        .environmentObject(userSearchViewModel)

                    SavedTracksView()
                        .environmentObject(savedTracksViewModel)

                    PostGridView()
                        .environmentObject(postsViewModel)
                }
                .padding(.top)
            }
            .padding(.horizontal)
            .background(Color(red: 242/255, green: 223/255, blue: 206/255))
        }
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
        .onAppear() {
            guard let user = userProfileViewModel.user else {
                print("User is nil. Cannot load profile.")
                return
            }

            userProfileViewModel.loadUser(with: user.username, token: user.spotifyToken) { updatedUser in
                DispatchQueue.main.async {
                    if let user = userProfileViewModel.user {
                        postsViewModel.loadPosts(for: user.id ?? "")
                        userSearchViewModel.loadFriends(userId: user.id ?? "") { success in
                            if success {
                                print("Friends successfully loaded on profile view")
                            }
                        }
                    }
                }
            }
        }
        .refreshable {
            guard let user = userProfileViewModel.user else {
                print("User is nil. Cannot load profile.")
                return
            }

            userProfileViewModel.loadUser(with: user.username, token: user.spotifyToken) { updatedUser in
                DispatchQueue.main.async {
                    if let user = userProfileViewModel.user {
                        postsViewModel.loadPosts(for: user.id ?? "")
                        userSearchViewModel.loadFriends(userId: user.id ?? "") { success in
                            if success {
                                print("Friends successfully loaded on profile view")
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showEditProfile) {
            if let user = userProfileViewModel.user {
                EditUserProfile(bio: user.bio, aesthetic: user.aesthetic)
                    .environmentObject(userProfileViewModel)
            }
        }
    }
}
