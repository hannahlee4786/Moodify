//
//  EditUserProfile.swift
//  Moodify
//
//  Created by Hannah Lee on 5/6/25.
//

import SwiftUI
import Combine

struct EditUserProfile: View {
    @EnvironmentObject var viewModel: UserProfileViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var bio: String = ""
    @State private var aesthetic: String = ""
    @State private var profileImageURL: String?
    
    let aestheticTextLimit = 3
    
    init(bio: String, aesthetic: String) {
        self._bio = State(initialValue: bio)
        self._aesthetic = State(initialValue: aesthetic)
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image("back")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                VStack {
                    if let urlString = profileImageURL, let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } placeholder: {
                            Image("profilewhite")
                                .resizable()
                                .scaledToFill()
                        }
                        .frame(width: 100, height: 100)
                        .padding()
                    }
                    
                    if let user = viewModel.user {
                        Text(user.username)
                            .font(.custom("BradleyHandITCTT-Bold", size: 24))
                            .foregroundStyle(Color.black)
                    }
                    
                    TextField("b i o", text: $bio)
                        .textFieldStyle(EditTextFieldStyle())
                        .padding()
                    
                    TextField("a e s t h e t i c", text: $aesthetic)
                        .textFieldStyle(EditTextFieldStyle())
                        .padding()
                        .onReceive(Just(aesthetic)) { _ in limitText(aestheticTextLimit) }
                    
                    Button(action: {
                        guard let id = viewModel.user?.id,
                              let token = viewModel.user?.spotifyToken else { return }
                        
                        viewModel.createOrUpdateUser(
                            id: id,
                            username: viewModel.user?.username ?? "",
                            bio: bio,
                            aesthetic: aesthetic,
                            spotifyToken: token,
                            profileImageURL: profileImageURL
                        ) { success in
                            if success {
                                dismiss()
                            }
                        }
                    }) {
                        Image("save")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 60)
                    }
                    .padding()
                    .disabled(viewModel.isLoading)
                }
                .padding(20)
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
            Spacer()
        }
        .padding()
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
        .onAppear {
            // Ensure the user data is loaded when the screen appears
            if let user = viewModel.user {
                bio = user.bio
                aesthetic = user.aesthetic
                profileImageURL = user.profileImageURL
            }
        }
    }
    
    func limitText(_ upper: Int) {
        if aesthetic.count > upper {
            aesthetic = String(aesthetic.prefix(upper))
        }
    }
}
