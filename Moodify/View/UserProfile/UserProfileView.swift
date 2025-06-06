//
//  UserProfileView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var viewModel: UserProfileViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                // If user info is still loading
                if viewModel.isLoading {
                    ProgressView()
                }
                // If user exists
                else if let user = viewModel.user {
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
                            
                            Text(user.username)
                                .font(.title2)
                                .bold()
                            
                            Text(user.bio)
                                .foregroundColor(.gray)
                            
                            Text(user.aesthetic)
                                .padding(.top, 4)
                            
                            SavedTracksView()
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                if viewModel.user == nil {
                    // Replace with your actual user ID and token
                    print("user is nil, can't load UserProfileView")
                    let userId = viewModel.user?.id ?? ""
                    let token = viewModel.user?.spotifyToken ?? ""
                    viewModel.loadUser(with: userId, token: token) { user in
                        DispatchQueue.main.async {
                            viewModel.user = user
                        }
                    }
                }
            }
            .navigationBarTitle("Your Profile", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let user = viewModel.user {
                        NavigationLink(destination: EditUserProfile(bio: user.bio, aesthetic: user.aesthetic)
                            .environmentObject(viewModel)) {
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
