//
//  SendRecView.swift
//  Moodify
//
//  Created by Hannah Lee on 7/11/25.
//

import SwiftUI

struct SendRecView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedTrack: TrackObject? = nil
    @State private var isPresentingSearch = false
    
    let friendUserId: String
    let friendUsername: String
    let requestMood: String
    let requestId: String

    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.black)
                }
                
                Text("Send Recommendation ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .padding(.leading, 16)
                
                Image(systemName: "paperplane")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Spacer()
            
            Text("To: \(friendUsername)")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Mood: \(requestMood)")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Add Song")
                .padding(.top, 20)
            
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
            
            if let track = selectedTrack {
                Text("Name: \(track.name)")
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Artist: \(track.artists[0].name)")
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack {
                Spacer()
                Button {
                    guard let track = selectedTrack else { return }
    
                    inboxViewModel.addRecommendation(friendId: friendUserId, username: userProfileViewModel.user?.username ?? "", song: track, requestId: requestId) { success in
                        if success {
                            DispatchQueue.main.async {
                                inboxViewModel.loadFriendsRequests(for: userProfileViewModel.user?.id ?? "")
    
                                // Reset recommendations page
                                selectedTrack = nil
    
                                print("Successfully saved recommendation!")
    
                                dismiss()
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("Send")
                            .fontWeight(.semibold)
                    }
                    .padding(14)
                    .frame(alignment: .trailing)
                    .background(Color(red: 255/255, green: 105/255, blue: 180/255))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
    }
}
