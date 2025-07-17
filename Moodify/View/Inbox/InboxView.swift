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
                    Image("thickleftarrow")
                        .resizable()
                        .frame(width: 30, height: 20)
                }
                
                Image("inboxheader")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 42)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                
                Spacer()
                
                Button {
                    showCreateRequest = true
                } label: {
                    Image("blueadd")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40)
                }
                .fullScreenCover(isPresented: $showCreateRequest) {
                    CreateRequestView()
                        .environmentObject(inboxViewModel)
                        .environmentObject(userProfileViewModel)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            
            TabView {
                UserRequestsView()
                    .tabItem {
                        Image("personwide")
                    }
                    .environmentObject(inboxViewModel)
                    .environmentObject(userProfileViewModel)
                
                FriendsRequestsView()
                    .tabItem {
                        Image("peoplewide")
                    }
                    .environmentObject(inboxViewModel)
                    .environmentObject(userProfileViewModel)
            }
        }
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
    }
}
