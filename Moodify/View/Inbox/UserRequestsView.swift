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
            Text("My Requests ☺︎")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            
            ScrollView {
                ForEach(inboxViewModel.userRequests) { request in
                    UserRequestCell(request: request)
                        .environmentObject(inboxViewModel)
                }
            }
        }
        .onAppear {
            if let userId = userProfileViewModel.user?.id {
                inboxViewModel.loadUserRequests(for: userId)
            }
        }
    }
}
