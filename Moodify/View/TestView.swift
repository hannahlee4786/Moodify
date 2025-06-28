//
//  TestView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/23/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
                VStack(spacing: 8) {
                    Text("hsyl")
                        .font(.title2)
                        .bold()
                    
                    Text("10 friends")
                    
                    Text("this is my super long bio")
                        .foregroundColor(.gray)
                    
                    Text("🎧🫧⭐️")
                        .padding(.top, 4)
                }
            }
        }
    }
}

#Preview {
    TestView()
}
