//
//  CommentCell.swift
//  Moodify
//
//  Created by Hannah Lee on 7/25/25.
//

import SwiftUI

struct CommentCell: View {
    let comment: Comment
    
    var body: some View {
        HStack {
            if let imageUrl = comment.userProfilePic,
               let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 8)
                } placeholder: {
                    Image("profilewhite")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 8)
                }
            }
            
            VStack {
                Text("@\(comment.username)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("BradleyHandITCTT-Bold", size: 18))
                    .foregroundStyle(Color.black)
                
                Text(comment.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 14))
                    .foregroundStyle(Color.black)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 2)
        )
        .padding(.horizontal, 10)
        .padding(.top, 10)
    }
}
