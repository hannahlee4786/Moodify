//
//  UserSearchCell.swift
//  Moodify
//
//  Created by Hannah Lee on 6/19/25.
//

import SwiftUI

struct UserSearchCell: View {
    let searchedUser: User
    var onSelect: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: self.searchedUser.profileImageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
            } placeholder: {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
            }
            
            VStack {
                Text(searchedUser.username)
                    .font(.title3)
                Text(searchedUser.aesthetic)
            }
            
            Spacer()
            
            Button {
                onSelect()
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            .padding(.trailing, 25)
        }
        .padding(.leading, 25)
    }
}

