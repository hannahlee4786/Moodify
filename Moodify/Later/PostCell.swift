//
//  PostCell.swift
//  Moodify
//
//  Created by Hannah Lee on 5/17/25.
//

import SwiftUI

struct PostCell: View {
    let post: Post
    
    var body: some View {
        NavigationLink(value: post) {
            AsyncImage(url: URL(string: post.imageURL)) { post in
                post
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
//                Color.gray.opacity(0.3) // a simple placeholder
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 160)
            .clipped()
        }
    }
}
