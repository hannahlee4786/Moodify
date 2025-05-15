//
//  EditUserProfile.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct EditUserProfile: View {
    @ObservedObject var viewModel: UserProfileViewModel

    @State private var username: String
    @State private var bio: String
    @State private var aesthetic: String
    @State private var profileImageURL: String?

    @Environment(\.presentationMode) var presentationMode  // Add this to manage view dismissal

    init(viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        _username = State(initialValue: viewModel.user?.username ?? "")
        _bio = State(initialValue: viewModel.user?.bio ?? "")
        _aesthetic = State(initialValue: viewModel.user?.aesthetic ?? "")
        _profileImageURL = State(initialValue: viewModel.user?.profileImageURL)
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
                viewModel.saveUser(username: username, bio: bio, aesthetic: aesthetic, profileImageURL: profileImageURL)
                
                // Dismiss the current view after saving
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .disabled(viewModel.isLoading)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .onAppear {
            // Ensure the user data is loaded when the screen appears
            if let userId = viewModel.user?.id {
                viewModel.loadUser(with: userId)
            }
        }
    }
}
