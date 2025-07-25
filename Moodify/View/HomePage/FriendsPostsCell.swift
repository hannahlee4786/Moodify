//
//  FriendsPostsCell.swift
//  Moodify
//
//  Created by Hannah Lee on 6/28/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct FriendsPostsCell: View {
    let post: Post
    
    @State private var isLiked = false
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                if let imageUrl = post.userProfilePic,
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
                
                Text(post.username)
                    .font(.custom("PingFangMO-Regular", size: 20))
                    .foregroundStyle(Color.black)

                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.top, 14)
            
            AsyncImage(url: URL(string: self.post.albumImageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            
            HStack {
                // Like feature for later
                Button {
                    if isLiked {
                        self.isLiked = false
                    } else {
                        self.isLiked = true
                    }
                } label: {
                    if isLiked {
                        Image("heartfill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundStyle(Color.pink)
                    } else {
                        Image("heart")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 20)
                            .foregroundStyle(Color.black)
                    }
                }
                .padding(.trailing, 6)
                Button {
                    // Comment feature
                } label: {
                    Image("comment")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .foregroundStyle(Color.black)
                }
                Spacer()
                Text(post.mood)
                    .padding(.trailing, 10)
                    .foregroundStyle(Color.black)
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 10)
            
            VStack(spacing: 4) {
                Text(post.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 20))
                    .foregroundStyle(Color.black)
                
                Text("song: \(post.trackName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 16))
                    .foregroundStyle(Color.black)
                
                Text("by: \(post.artistName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 16))
                    .foregroundStyle(Color.black)
                
                Text(DateFormatter.postDateFormatter.string(from: post.date))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 12))
                    .foregroundStyle(Color.black)
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 2)
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}
