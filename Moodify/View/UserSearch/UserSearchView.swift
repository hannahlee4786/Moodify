//
//  UserSearchView.swift
//  Moodify
//
//  Created by Hannah Lee on 6/19/25.
//

import SwiftUI

struct UserSearchView: View {
    @Binding var selectedUser: User?
    @EnvironmentObject var userSearchViewModel: UserSearchViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @State private var searchedUser = ""

    var body: some View {
        VStack(spacing: 20) {
            Image("searchuser")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 46)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
            
            TextField("e n t e r   u s e r n a m e", text: $searchedUser)
                .frame(width: 350)
                .textFieldStyle(SearchTextFieldStyle())
                .onSubmit {
                    userSearchViewModel.searchUser(username: searchedUser) { success in
                        if success {
                            print("Successfully displayed searched users.")
                        }
                    }
                }
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(userSearchViewModel.searchResults, id: \.id) { friend in
                        UserSearchCell(searchedUser: friend)
                            .environmentObject(userProfileViewModel)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.horizontal, 10)
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
    }
}
