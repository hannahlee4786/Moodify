//
//  SpotifySearchView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/7/25.
//

import SwiftUI

struct SpotifySearchView: View {
//    @StateObject private var viewModel = SpotifySearchViewModel()
    @AppStorage("spotifyToken") var spotifyToken: String?
    @State private var text: String = ""
    var onSelectSong: (Song) -> Void
    
    // Pass in the User and token from LoginView or elsewhere
//    init(user: User, onSelectSong: @escaping (Song) -> Void) {
//        _viewModel = StateObject(wrappedValue: SpotifySearchViewModel(user: user))
//        self.onSelectSong = onSelectSong
//    }
    
    var body: some View {
        VStack {
            TextField("Search for a song...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    print("Token on search submit: \(spotifyToken ?? "No token available")")
//                    viewModel.search()
                }
            
//            if viewModel.isLoading {
//                ProgressView()
//            } else {
//                List(viewModel.results, id: \.id) { song in
//                    Button {
//                        onSelectSong(song)
//                    } label: {
//                        HStack {
//                            AsyncImage(url: URL(string: song.albumImageURL)) { image in
//                                image.resizable()
//                            } placeholder: {
//                                Color.gray
//                            }
//                            .frame(width: 50, height: 50)
//                            .cornerRadius(6)
//                            
//                            VStack(alignment: .leading) {
//                                Text(song.title).bold()
//                                Text(song.artist).foregroundColor(.secondary)
//                            }
//                        }
//                    }
//                }
//            }
        }
        .onAppear {
            print("Spotify token on appear: \(spotifyToken ?? "No token")")
        }
    }
}

