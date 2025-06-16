//
//  PostCell.swift
//  Moodify
//
//  Created by Hannah Lee on 5/17/25.
//

import SwiftUI

struct PostCell: View {
    @EnvironmentObject var viewModel: UserProfileViewModel
    let post: Post
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                if let imageUrl = viewModel.user?.profileImageURL,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 4)
                    } placeholder: {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 4)
                    }
                }
                
                if let user = viewModel.user {
                    Text(user.username)
                        .font(.title2)
                }

                Spacer()

                Text(post.mood)
                    .padding(.trailing, 10)
            }
            .padding(.leading, 10)
            .padding(.top, 40)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            AsyncImage(url: URL(string: self.post.albumImageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 350, height: 350)
            .clipped()
            
            Text(post.caption)
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
            
            VStack(spacing: 4) {
                Text("Song: \(post.trackName)")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("By: \(post.artistName)")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
