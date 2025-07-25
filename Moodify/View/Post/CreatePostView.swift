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
        VStack {
            Image("createpost")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 42)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
                .padding(.bottom, 50)
            
            ScrollView {
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
                        Image("pinkadd")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    }
                }
                .padding(.bottom, 30)
                .sheet(isPresented: $isPresentingSearch) {
                    SearchView(selectedTrack: $selectedTrack)
                }
                
                TextField("c a p t i o n", text: $caption)
                    .textFieldStyle(EditTextFieldStyle())
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                
                TextField("m o o d - e m o j i s", text: $mood)
                    .textFieldStyle(EditTextFieldStyle())
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                    .onReceive(Just(mood)) { _ in limitText(moodTextLimit) }
                
                if let track = selectedTrack {
                    Text("Song: \(track.name)")
                        .padding(.leading, 20)
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("PingFangMO-Regular", size: 16))
                        .foregroundStyle(Color.black)
                    
                    Text("Artist: \(track.artists.first?.name ?? "")")
                        .padding(.leading, 20)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom("PingFangMO-Regular", size: 16))
                        .foregroundStyle(Color.black)
                }
                
                Button {
                    guard let track = selectedTrack, let user = userProfileViewModel.user else { return }
                    
                    postsViewModel.savePost(track: track, caption: caption, mood: mood, user: user) { success in
                        if success {
                            DispatchQueue.main.async {
                                navigateToSuccess = true
                                postsViewModel.isLoading = false
                                                                
                                // Reset post page
                                caption = ""
                                mood = ""
                                selectedTrack = nil
                                
                                selectedTab = 3
                            }
                        }
                        print(postsViewModel.posts)
                    }
                } label: {
                    Image("post")
                        .padding(.top, 30)
                }
                .disabled(userProfileViewModel.isLoading)
                
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
    }
    
    func limitText(_ upper: Int) {
        if mood.count > upper {
            mood = String(mood.prefix(upper))
        }
    }
}
