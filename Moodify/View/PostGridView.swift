//
//  PostGridView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/7/25.
//

import SwiftUI

struct PostGridView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    var userId: String
    
    // Add state to track debugging info
    @State private var debugMessage: String = ""
    @State private var refreshTrigger = false  // Used to force refresh

    var body: some View {
        VStack {
            // Header with refresh button
            HStack {
                Text("Posts")
                    .font(.largeTitle)
                
                Spacer()
                
                Button(action: {
                    // Force refresh
                    print("Manually refreshing posts")
                    viewModel.loadUser(with: userId)
                    refreshTrigger.toggle()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            // Debug info section
//            if !debugMessage.isEmpty {
//                VStack(alignment: .leading) {
//                    Text("Debug Info:")
//                        .font(.caption)
//                        .fontWeight(.bold)
//                    
//                    Text(debugMessage)
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                .padding(.horizontal)
//                .padding(.bottom, 8)
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }

            if viewModel.isLoading {
                ProgressView("Loading posts...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else if let posts = viewModel.user?.posts, !posts.isEmpty {
                // Display post count
                Text("\(posts.count) posts")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(posts) { post in
                            VStack {
                                // Post image (handle both URL and direct UIImage)
                                if let imageURL = post.imageURL, !imageURL.isEmpty, let url = URL(string: imageURL) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .frame(height: 150)
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: 150)
                                                .clipped()
                                                .cornerRadius(8)
                                        case .failure:
                                            VStack {
                                                Image(systemName: "exclamationmark.triangle")
                                                Text("Failed to load")
                                                    .font(.caption)
                                            }
                                            .frame(height: 150)
                                            .foregroundColor(.red)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    // Use the in-memory image
                                    Image(uiImage: post.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 150)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                                
                                // Caption
                                Text(post.caption)
                                    .font(.caption)
                                    .lineLimit(2)
                                    .padding(.top, 4)
                            }
                            .padding(8)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                    }
                    .padding(.horizontal)
                }
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No posts yet")
                        .font(.headline)
                    
//                    if viewModel.user == nil {
//                        Text("User data not loaded")
//                            .font(.caption)
//                            .foregroundColor(.red)
//                    } else {
//                        Text("Try adding a post from the Add tab")
//                            .font(.body)
//                            .foregroundColor(.gray)
//                    }
//                    
//                    // Show debug button
//                    Button("Show Debug Info") {
//                        updateDebugInfo()
//                    }
//                    .padding()
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
                }
                .padding()
            }
        }
//        .onAppear {
//            // Update debug info
//            updateDebugInfo()
//            
//            // Ensure that user data is loaded when the screen appears
//            if viewModel.user == nil || viewModel.user?.id != userId {
//                print("Loading user in PostGridView")
//                viewModel.loadUser(with: userId)
//            } else {
//                print("User already loaded: \(String(describing: viewModel.user?.username))")
//                print("Posts count: \(viewModel.user?.posts.count ?? 0)")
//            }
//        }
//        .onChange(of: refreshTrigger) { _ in
//            // Update debug info when refresh is triggered
//            updateDebugInfo()
//        }
    }
    
    // Debug info update function
    private func updateDebugInfo() {
        debugMessage = """
        User ID: \(userId)
        User loaded: \(viewModel.user != nil ? "Yes" : "No")
        Username: \(viewModel.user?.username ?? "Unknown")
        Posts count: \(viewModel.user?.posts.count ?? 0)
        Loading state: \(viewModel.isLoading ? "Loading" : "Idle")
        Error: \(viewModel.errorMessage ?? "None")
        """
    }
}

struct PostGridView_Previews: PreviewProvider {
    static var previews: some View {
        PostGridView(viewModel: UserProfileViewModel(), userId: "test-user-id")
    }
}
