//
//  LoginView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct LoginView: View {
    // Create a single shared instance of the view model
    @StateObject private var viewModel = UserProfileViewModel()
    
    @State private var isLoggingIn = false
    @State private var isLoggedIn = false
    @AppStorage("currentUserID") var currentUserID: String?
    @AppStorage("spotifyToken") var spotifyToken: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()

                Text("Moodify")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Your daily music diary")
                    .font(.headline)
                    .foregroundColor(.gray)

                Spacer()
                
                if isLoggingIn {
                    ProgressView("Logging in...")
                } else {
                    Button(action: startSpotifyLogin) {
                        HStack {
                            Image(systemName: "music.note")
                            Text("Log in with Spotify")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                MainTabView()
                    .environmentObject(viewModel)
            }
        }
    }

    // Complete function for user login
    private func startSpotifyLogin() {
        isLoggingIn = true

        // Start user login authentication
        SpotifyAuthManager.spotifyAuthManager.startLogin { success in
            DispatchQueue.main.async {
                isLoggingIn = false

                guard success, let token = SpotifyAuthManager.spotifyAuthManager.accessToken else {
                    print("Login failed: No token.")
                    return
                }

                self.spotifyToken = token

                // Get user profile
                SpotifyAuthManager.spotifyAuthManager.getUserProfile { id, name, imageURL in
                    guard let id = id, let name = name else {
                        print("Failed to fetch user profile.")
                        return
                    }

                    // Load user from Firestore or create new user
                    viewModel.loadUser(with: id, token: self.spotifyToken!) { existingUser in
                        DispatchQueue.main.async {
                            let userToSave: User

                            if var existingUser = existingUser {
                                print("Existing user found: \(existingUser.username)")
                                existingUser.spotifyToken = token
                                userToSave = existingUser
                            } else {
                                print("Creating new user")
                                userToSave = User(
                                    id: id,
                                    username: name,
                                    bio: "Hi, I'm new to Moodify!",
                                    aesthetic: "🎧💗✨",
                                    spotifyToken: token,
                                    profileImageURL: imageURL
                                )
                            }

                            // Save user to Firestore
                            viewModel.createOrUpdateUser(
                                id: userToSave.id ?? "",
                                username: userToSave.username,
                                bio: userToSave.bio,
                                aesthetic: userToSave.aesthetic,
                                spotifyToken: userToSave.spotifyToken,
                                profileImageURL: userToSave.profileImageURL
                            ) { firestoreSuccess in
                                DispatchQueue.main.async {
                                    if firestoreSuccess {
                                        currentUserID = id
                                        isLoggedIn = true
                                        print("User saved to Firestore.")
                                    } else {
                                        print("Failed to save user to Firestore.")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
    
