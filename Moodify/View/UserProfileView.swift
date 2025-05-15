//
//  UserProfileView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI

struct UserProfileView: View {
    @ObservedObject var viewModel: UserProfileViewModel
    let userId: String
    @State private var isEditing = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let user = viewModel.user {
                    VStack(spacing: 12) {
                        if let urlString = user.profileImageURL,
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        }

                        Text(user.username)
                            .font(.title2)
                            .bold()

                        Text(user.bio)
                            .foregroundColor(.gray)

                        Text("\(user.aesthetic)")
                            .italic()
                            .padding(.top, 4)
                    }
                    .padding()
                    .toolbar {
                        Button("Edit") {
                            isEditing.toggle()
                        }
                    }
                    .background(
                        NavigationLink(
                            destination: EditUserProfile(viewModel: viewModel),
                            isActive: $isEditing,
                            label: { EmptyView() }
                        )
                    )
                } else if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                viewModel.loadUser(with: userId)
            }
        }
    }
}
