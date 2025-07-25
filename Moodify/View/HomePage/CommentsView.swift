//
//  CommentsView.swift
//  Moodify
//
//  Created by Hannah Lee on 7/25/25.
//

import SwiftUI

struct CommentsView: View {
    @EnvironmentObject var homePageViewModel: HomePageViewModel
    @State var comment = ""
    @State private var comments: [Comment] = []

    let post: Post
    let username: String
    let profilePic: String?

    var body: some View {
        VStack {
            Text("c o m m e n t s")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.custom("BradleyHandITCTT-Bold", size: 28))
                .foregroundStyle(Color.black)
            
            ScrollView {
                ForEach(comments) { comment in
                    CommentCell(comment: comment)
                }
            }

            HStack {
                if let imageUrl = profilePic,
                   let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 8)
                    } placeholder: {
                        Image("profilebeige")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding(.trailing, 8)
                    }
                }

                TextField("a d d  c o m m e n t", text: $comment)
                    .textFieldStyle(SearchTextFieldStyle())
                    .padding(.trailing, 4)

                Button {
                    homePageViewModel.addComment(post: post, username: username, profilePic: profilePic, comment: comment)
                    comment = ""

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        loadComments()
                    }
                } label: {
                    Image("circleaddbeige")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                }
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 30)
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
        .onAppear {
            loadComments()
        }
    }

    private func loadComments() {
        homePageViewModel.loadComments(for: post) { fetchedComments in
            DispatchQueue.main.async {
                self.comments = fetchedComments
            }
        }
    }
}
