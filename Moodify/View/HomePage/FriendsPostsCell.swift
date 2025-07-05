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
                    .font(.title2)
            }
            .padding(.leading, 16)
            .padding(.top, 40)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            AsyncImage(url: URL(string: self.post.albumImageUrl)) { image in
                image
                    .resizable()
                    .frame(width: 350, height: 350)
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            
            HStack {
                Text(post.caption)
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3)
                Text(post.mood)
                    .padding(.trailing, 12)
            }
            
            VStack(spacing: 4) {
                Text("Song: \(post.trackName)")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("By: \(post.artistName)")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(DateFormatter.postDateFormatter.string(from: post.date))
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
            }
        }
    }
}
