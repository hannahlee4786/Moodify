//
//  CreatePostView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/7/25.
//

import SwiftUI
import Combine

struct CreatePostView: View {
    @Binding var selectedTab: Int
    
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @State private var selectedTrack: TrackObject? = nil
    @State private var isPresentingSearch = false
    @State private var navigateToSuccess = false
    @State var caption = ""
    @State var mood = ""
    
    let moodTextLimit = 3
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Create Post ☆")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
                .padding(.leading, 20)
            
            Spacer()
            
            Button {
                isPresentingSearch = true
            } label: {
                if let track = selectedTrack {
                    AsyncImage(url: URL(string: track.album.images[0].url)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 100, height: 100)
                    .clipped()
                }
                else {
                    Image(systemName: "plus.rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 150)
                        .padding()
                        .foregroundColor(Color(red: 255/255, green: 105/255, blue: 180/255))
                }
            }
            .sheet(isPresented: $isPresentingSearch) {
                SearchView(selectedTrack: $selectedTrack)
            }
            
            TextField("Caption", text: $caption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 10)
            
            TextField("Mood (Up to 3 Emojis)", text: $mood)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 10)
                .onReceive(Just(mood)) { _ in limitText(moodTextLimit) }
            
            if let track = selectedTrack {
                Text("Name: \(track.name)")
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Artist: \(track.artists.first?.name ?? "")")
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button {
                guard let track = selectedTrack, let user = userProfileViewModel.user else { return }
                
                postsViewModel.savePost(track: track, caption: caption, mood: mood, user: user) { success in
                    if success {
                        DispatchQueue.main.async {
                            navigateToSuccess = true
                            postsViewModel.isLoading = false
                                                                                    
                            postsViewModel.loadPosts(for: user.id ?? "")
                            
                            // Reset post page
                            caption = ""
                            mood = ""
                            selectedTrack = nil
                            
                            print("Successfully saved post!")
                            print(postsViewModel.posts)
                            
                            selectedTab = 0
                        }
                    }
                }
            } label: {
                HStack {
                    Text("Post")
                        .fontWeight(.semibold)
                }
                .padding()
                .frame(alignment: .trailing)
                .background(Color(red: 255/255, green: 105/255, blue: 180/255))
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .disabled(userProfileViewModel.isLoading)
            
            Spacer()
        }
    }
    
    func limitText(_ upper: Int) {
        if mood.count > upper {
            mood = String(mood.prefix(upper))
        }
    }
}
