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
                        .font(.title2)
                }

                Spacer()
                
                Button {
                    showAlert = true
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 10)
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
            .padding(.leading, 10)
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
                    .padding(.trailing, 10)
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

// For formatting post's date
extension DateFormatter {
    static let postDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
