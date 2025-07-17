//
//  UserRequestsView.swift
//  Moodify
//
//  Created by Hannah Lee on 6/18/25.
//

import SwiftUI

struct UserRequestsView: View {
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text("my requests")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("BradleyHandITCTT-Bold", size: 32))
                .foregroundStyle(Color.black)
                .padding(.leading, 20)
            
            ScrollView {
                ForEach(inboxViewModel.userRequests) { request in
                    UserRequestCell(request: request)
                        .environmentObject(inboxViewModel)
                }
            }
            
            Spacer()
        }
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
        .onAppear {
            if let userId = userProfileViewModel.user?.id {
                inboxViewModel.loadUserRequests(for: userId)
            }
        }
    }
}
