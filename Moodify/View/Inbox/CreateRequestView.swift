//
//  MakeRequestView.swift
//  Moodify
//
//  Created by Hannah Lee on 7/11/25.
//

import SwiftUI
import Combine

struct EditTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .stroke(Color.black, lineWidth: 2)
        )
        .background(Color.white)
        .padding()
    }
}

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
                    Image("thickleftarrow")
                        .resizable()
                        .frame(width: 30, height: 20)
                }
                
                Image("requestheader")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
            }
                        
            TextField("m o o d - e m o j i s", text: $mood)
                .textFieldStyle(EditTextFieldStyle())
                .padding(.top, 30)
                .onReceive(Just(mood)) { _ in limitText(moodTextLimit) }
            
            TextField("c o m m e n t", text: $comment)
                .textFieldStyle(EditTextFieldStyle())
                .padding(.top, 10)
                .padding(.bottom, 40)
            
            HStack {
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
                    Image("request")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
    }
    
    func limitText(_ upper: Int) {
        if mood.count > upper {
            mood = String(mood.prefix(upper))
        }
    }
}
