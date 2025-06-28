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
    
    var body: some View {
        NavigationStack {
            VStack {
                // If user info is still loading
                if userProfileViewModel.isLoading {
                    ProgressView()
                }
                // If user exists
                else if let user = userProfileViewModel.user {
                    ScrollView {
                        VStack(spacing: 12) {
                            if let imageUrl = user.profileImageURL,
                               let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .scaledToFill()
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            }
                            
                            VStack(spacing: 8) {
                                Text(user.username)
                                    .font(.title2)
                                    .bold()
                                
                                if userSearchViewModel.friends.count != 1 {
                                    Text("\(userSearchViewModel.friends.count) friends")
                                }
                                else {
                                    Text("\(userSearchViewModel.friends.count) friend") // 1 friend
                                }
                                
                                Text(user.bio)
                                    .foregroundColor(.gray)
                                
                                Text(user.aesthetic)
                                    .padding(.top, 4)
                            }
                            
                            SavedTracksView()
                                .environmentObject(savedTracksViewModel)
                            
                            PostGridView()
                                .environmentObject(postsViewModel)
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                guard let user = userProfileViewModel.user else {
                    print("User is nil. Cannot load profile.")
                    return
                }

                userProfileViewModel.loadUser(with: user.username, token: user.spotifyToken) { updatedUser in
                    DispatchQueue.main.async {
                        if let user =  userProfileViewModel.user {
                            postsViewModel.loadPosts(for: user.id ?? "")
                        }
                    }
                }
            }
            .navigationBarTitle("Your Profile", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let user = userProfileViewModel.user {
                        NavigationLink(destination: EditUserProfile(bio: user.bio, aesthetic: user.aesthetic)
                            .environmentObject(userProfileViewModel)) {
                            Text("Edit")
                        }
                    }
                }
            }
            .navigationDestination(for: SavedTrackObject.self) { track in
                SavedTrackDetailPage(savedTrack: track)
            }
        }
    }
}
