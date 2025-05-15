//
//  LoginView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct LoginView: View {
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
                            SwiftUI.Image(systemName: "music.note")
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
            }
        }
    }

    private func startSpotifyLogin() {
        isLoggingIn = true
        SpotifyAuthManager.shared.startLogin { success in
            DispatchQueue.main.async {
                isLoggingIn = false
                if success, let token = SpotifyAuthManager.shared.accessToken {
                    print("Login successful! Token: \(token)")
                    self.spotifyToken = token  // Set the token here in AppStorage

                    // Now, update the User object with the token
                    SpotifyAPIService.shared.fetchUserProfile(token: token) { id, name, imageURL in
                        guard let id = id, let name = name else {
                            print("Failed to fetch user profile.")
                            return
                        }

                        // Fetch user from Firestore or create a new one
                        UserService.shared.fetchUser(byId: id) { existingUser in
                            DispatchQueue.main.async {
                                let userToSave: User
                                if var existingUser = existingUser {
                                    print("Existing user found: \(existingUser.username)")
                                    existingUser.spotifyToken = token // Set the token here
                                    userToSave = existingUser
                                } else {
                                    print("New user — using default bio/aesthetic.")
                                    userToSave = User(
                                        id: id,
                                        username: name,
                                        bio: "Hi, I'm new to Moodify!",
                                        aesthetic: "🎧💗✨",
                                        spotifyToken: token,  // Set token here as well
                                        profileImageURL: imageURL,
                                        likedTracks: [],
                                        posts: []
                                    )
                                }

                                // Save or update the user in Firestore
                                UserService.shared.createOrUpdateUser(
                                    id: userToSave.id,
                                    username: userToSave.username,
                                    bio: userToSave.bio,
                                    aesthetic: userToSave.aesthetic,
                                    spotifyToken: userToSave.spotifyToken,  // Save token to Firestore as well
                                    profileImageURL: userToSave.profileImageURL
                                ) { firestoreSuccess in
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
                } else {
                    print("Login failed: No token.")
                }
            }
        }
    }
}
