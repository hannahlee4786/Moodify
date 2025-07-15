//
//  PostCell.swift
//  Moodify
//
//  Created by Hannah Lee on 5/17/25.
//

import SwiftUI

struct PostCell: View {
    @EnvironmentObject var viewModel: UserProfileViewModel
    @EnvironmentObject var postsViewModel: PostsViewModel
    
    @State private var showAlert = false
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
                        .font(.custom("PingFangMO-Regular", size: 20))
                }

                Spacer()
                
                Button {
                    showAlert = true
                } label: {
                    Image("trash")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.red)
                }
                .alert("Confirm to Delete Post", isPresented: $showAlert) {
                    Button("Confirm", role: .destructive) {
                        // Delete post and rerender
                        if let userId = viewModel.user?.id {
                            postsViewModel.deletePost(post: post, userId: userId)
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        // Does nothing
                    }
                 } message: {
                     Text("Confirm or Cancel Deletion")
                 }

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
                    .clipped()
            } placeholder: {
                Color.red.opacity(0.3)
            }
            
            HStack {
                Button {
                    // Like feature
                } label: {
                    Image("heartfill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .foregroundStyle(Color.pink)
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
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 10)
            
            VStack(spacing: 4) {
                Text(post.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 20))
                    .foregroundStyle(Color.black)
                
                Text("Song: \(post.trackName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 16))
                    .foregroundStyle(Color.black)
                
                Text("By: \(post.artistName)")
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
                .stroke(Color.black, lineWidth: 4)
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// For formatting post's date
extension DateFormatter {
    static let postDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
