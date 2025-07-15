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
        VStack(spacing: 2) {
            Spacer()

            Image("moodify")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 100)
            
            Text("y o u r   m u s i c   d i a r y  ♡")
                .font(.custom("PingFangMO-Regular", size: 15))
                .foregroundStyle(Color.black)
            
            if isLoggingIn {
                ProgressView("Logging in...")
            } else {
                Button(action: startSpotifyLogin) {
                    Image("loginbutton")
                }
                .padding(.top, 40)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
        .fullScreenCover(isPresented: $isLoggedIn) {
            MainTabView()
                .environmentObject(viewModel)
        }
    }

    // Complete function for user login
    private func startSpotifyLogin() {
        isLoggingIn = true

        // Reset any variables set from previous login
        SpotifyAuthManager.spotifyAuthManager.resetSession()

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
    
