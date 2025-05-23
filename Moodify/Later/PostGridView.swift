//
//  PostGridView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/7/25.
//

import SwiftUI

struct PostGridView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    @State private var viewDidLoad = false
    var userId: String
    
    let items: [GridItem] = [
        GridItem(.flexible(minimum: 120)),
        GridItem(.flexible(minimum: 120))
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if viewModel.isLoading {
                ProgressView()
            } else {
                LazyVGrid(columns: items, spacing: 10) {
                    ForEach(viewModel.user?.posts ?? [], id: \.id) { post in
                        PostCell(post: post)
                    }
                }
                .padding()
            }
        }
    }
}
