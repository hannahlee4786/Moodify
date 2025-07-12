//
//  MakeRequestView.swift
//  Moodify
//
//  Created by Hannah Lee on 7/11/25.
//

import SwiftUI
import Combine

struct CreateRequestView: View {
    @EnvironmentObject var inboxViewModel: InboxViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var mood = ""
    @State private var comment = ""
    
    let moodTextLimit = 3
    
    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.black)
                }
                
                Text("Create Request ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                    .padding(.leading, 16)
                
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)
            
            Spacer()
            
            TextField("Mood (3 emojis)", text: $mood)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 10)
                .onReceive(Just(mood)) { _ in limitText(moodTextLimit) }
            
            TextField("Comment", text: $comment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 10)
        
            HStack {
                Spacer()
                
                Button {
                    guard let user = userProfileViewModel.user else { return }
                    
                    inboxViewModel.makeRequest(userID: user.id ?? "", description: comment, mood: mood, user: user) { success in
                        if success {
                            DispatchQueue.main.async {
                                // Reset CreateReqeustView textfields
                                comment = ""
                                mood = ""
                                
                                inboxViewModel.loadUserRequests(for: user.id ?? "")
                                
                                dismiss()
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text("Request")
                            .fontWeight(.semibold)
                    }
                    .padding(14)
                    .frame(alignment: .trailing)
                    .background(Color(red: 255/255, green: 105/255, blue: 180/255))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            
            Spacer()
        }
    }
    
    func limitText(_ upper: Int) {
        if mood.count > upper {
            mood = String(mood.prefix(upper))
        }
    }
}
