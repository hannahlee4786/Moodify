//
//  SwiftUIView.swift
//  Moodify
//
//  Created by Hannah Lee on 7/12/25.
//

import SwiftUI

struct UITestView: View {
    @State var mood = ""
    @State var comment = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
//                    dismiss()
                } label: {
                    Image("thickleftarrow")
                        .resizable()
                        .frame(width: 30, height: 20)
                }
                
                Image("sendrecheader")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 38)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
            }
                        
            Text("to: @username")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("BradleyHandITCTT-Bold", size: 24))
                .foregroundStyle(Color.black)
                .padding(.top, 20)

            Text("mood: ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("BradleyHandITCTT-Bold", size: 20))
                .foregroundStyle(Color.black)
                .padding(.bottom, 20)
            
            Button {
//                isPresentingSearch = true
            } label: {
//                if let track = selectedTrack {
//                    AsyncImage(url: URL(string: track.album.images[0].url)) { image in
//                        image
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                    } placeholder: {
//                        Color.gray.opacity(0.3)
//                    }
//                    .frame(width: 100, height: 100)
//                    .clipped()
//                }
//                else {
                Image("pinkadd")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
//                }
            }
//            .sheet(isPresented: $isPresentingSearch) {
//                SearchView(selectedTrack: $selectedTrack)
//            }
            
//            if let track = selectedTrack {
                Text("song: ")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("BradleyHandITCTT-Bold", size: 24))
                .foregroundStyle(Color.black)
                .padding(.top, 20)
                
                Text("artist")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("BradleyHandITCTT-Bold", size: 24))
                .foregroundStyle(Color.black)
//            }
            
            
                Button {
//                    guard let track = selectedTrack else { return }
//    
//                    inboxViewModel.addRecommendation(friendId: friendUserId, username: userProfileViewModel.user?.username ?? "", song: track, requestId: requestId) { success in
//                        if success {
//                            DispatchQueue.main.async {
//                                inboxViewModel.loadFriendsRequests(for: userProfileViewModel.user?.id ?? "")
//    
//                                // Reset recommendations page
//                                selectedTrack = nil
//    
//                                print("Successfully saved recommendation!")
//    
//                                dismiss()
//                            }
//                        }
//                    }
                } label: {
                    Image("send")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 54)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.top, 20)
            
            
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.trailing, 20)
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
    }
}

#Preview {
    UITestView()
}
