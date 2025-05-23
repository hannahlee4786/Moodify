//
//  EditUserProfile.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct EditUserProfile: View {
    @EnvironmentObject var viewModel: UserProfileViewModel

    @State private var username: String
    @State private var bio: String
    @State private var aesthetic: String
    @State private var profileImageURL: String?

    @Environment(\.presentationMode) var presentationMode  // Add this to manage view dismissal
    
    // Initializing @State private variables
    init(username: String, bio: String, aesthetic: String) {
        self._username = State(initialValue: username)
        self._bio = State(initialValue: bio)
        self._aesthetic = State(initialValue: aesthetic)
    }

    var body: some View {
        VStack {
            if let urlString = profileImageURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            }

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Bio", text: $bio)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Aesthetic", text: $aesthetic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Save") {
                guard let id = viewModel.user?.id,
                    let token = viewModel.user?.spotifyToken else { return }

                viewModel.createOrUpdateUser(
                    id: id,
                    username: username,
                    bio: bio,
                    aesthetic: aesthetic,
                    spotifyToken: token,
                    profileImageURL: profileImageURL
                ) { success in
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .padding()
            .disabled(viewModel.isLoading)
        }
        .padding()
        .onAppear {
            // Ensure the user data is loaded when the screen appears
            if let user = viewModel.user {
                username = user.username
                bio = user.bio
                aesthetic = user.aesthetic
                profileImageURL = user.profileImageURL
            }
        }
    }
}
