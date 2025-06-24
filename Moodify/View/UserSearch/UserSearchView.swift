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
    @State private var searchedUser = ""

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("Search User")
                    .font(.largeTitle)
                    .padding(.leading, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            TextField("Enter Username", text: $searchedUser)
                .frame(width: 350)
                .textFieldStyle(.roundedBorder)
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
                        UserSearchCell(searchedUser: friend) {
                            selectedUser = friend
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 20)
    }
}
