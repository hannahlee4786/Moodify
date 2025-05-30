//
//  EditUserProfile.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct EditUserProfile: View {
    @EnvironmentObject var viewModel: UserProfileViewModel

    @State private var bio: String
    @State private var aesthetic: String
    @State private var profileImageURL: String?

    @Environment(\.presentationMode) var presentationMode  // Add this to manage view dismissal
    
    // Initializing @State private variables
    init(bio: String, aesthetic: String) {
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
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()
            }

            if let user = viewModel.user {
                Text(user.username)
            }

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
                    username: viewModel.user?.username ?? "",
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
                bio = user.bio
                aesthetic = user.aesthetic
                profileImageURL = user.profileImageURL
            }
        }
    }
}
