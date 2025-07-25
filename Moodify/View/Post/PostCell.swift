//
//  PostCell.swift
//  Moodify
//
//  Created by Hannah Lee on 5/17/25.
//

import SwiftUI

struct PostCell: View {
    @EnvironmentObject var postsViewModel: PostsViewModel
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    
    @State private var showAlert = false
    @State private var isPresentingComments = false

    var isLiked: Bool {
        post.likedUsers.contains(post.username)
    }

    let post: Post
    
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
                        Image("profilewhite")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 4)
                    }
                }
                
                Text(post.username)
                    .font(.custom("PingFangMO-Regular", size: 20))
                    .foregroundStyle(Color.black)

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
                        postsViewModel.deletePost(post: post, userId: post.userId)
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
                // Like feature
                Button {
                    if isLiked {
                        homePageViewModel.unlike(post: post, username: post.username)
                    }
                    else {
                        homePageViewModel.like(post: post, username: post.username)
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
                .padding(.trailing, 2)
                
                Text("\(post.likedUsers.count)")
                    .font(.custom("PingFangMO-Regular", size: 16))
                    .foregroundStyle(Color.black)
                    .padding(.trailing, 6)
                
                // Comment feature
                Button {
                    isPresentingComments = true
                } label: {
                    Image("comment")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .foregroundStyle(Color.black)
                }
                .sheet(isPresented: $isPresentingComments) {
                    CommentsView(post: post, username: userProfileViewModel.user?.username ?? "", profilePic: userProfileViewModel.user?.profileImageURL ?? "")
                        .environmentObject(homePageViewModel)
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

// For formatting post's date
extension DateFormatter {
    static let postDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
