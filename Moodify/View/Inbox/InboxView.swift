//
//  InboxView.swift
//  Moodify
//
//  Created by Hannah Lee on 6/18/25.
//

import SwiftUI

struct InboxView: View {
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showCreateRequest = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.black)
                }
                
                Text("Inbox ")
                    .font(.largeTitle)
                    .padding(.leading, 16)
                
                Image(systemName: "tray.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Spacer()
                
                Button {
                    showCreateRequest = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 20)
                        .foregroundColor(Color(red: 255/255, green: 105/255, blue: 180/255))
                }
                .fullScreenCover(isPresented: $showCreateRequest) {
                    CreateRequestView()
                        .environmentObject(inboxViewModel)
                        .environmentObject(userProfileViewModel)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            TabView {
                UserRequestsView()
                    .tabItem {
                        Image(systemName: "person")
                    }
                    .environmentObject(inboxViewModel)
                    .environmentObject(userProfileViewModel)
                
                FriendsRequestsView()
                    .tabItem {
                        Image(systemName: "person.3")
                    }
                    .environmentObject(inboxViewModel)
                    .environmentObject(userProfileViewModel)
            }
        }
    }
}
