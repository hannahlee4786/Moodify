//
//  UserProfileView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var viewModel: UserProfileViewModel
    
    @State private var isEditing = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let user = viewModel.user {
                    VStack(spacing: 12) {
                        if let urlString = user.profileImageURL,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray
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

                        // Add PostGridView
                    }
                    NavigationLink(
                        destination: EditUserProfile(username: user.username, bio: user.bio, aesthetic: user.aesthetic),
                        isActive: $isEditing
                    ) {
                        EmptyView()
                    }
                    .hidden()
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
                    Button("Edit") {
                        isEditing.toggle()
                    }
                }
            }
        }
    }
}
