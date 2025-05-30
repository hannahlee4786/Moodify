//
//  TestView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/23/25.
//

import SwiftUI

struct TestView: View {
    @State private var bio = ""
    @State private var aesthetic = ""
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .scaledToFill()
                .padding()
            
            Text("user")
            
            TextField("Bio", text: $bio)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Aesthetic", text: $aesthetic)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save") {
                print("saved")
            }
            .padding()
        }
    }
}

#Preview {
    TestView()
}
