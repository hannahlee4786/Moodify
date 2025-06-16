//
//  TestView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/23/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "plus.rectangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 150)
                .padding()
                .foregroundColor(Color(red: 255/255, green: 105/255, blue: 180/255))
            
            Text("Caption")
                .padding(.leading, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
            
            VStack(spacing: 4) {
                Text("Song Title")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Artist")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    TestView()
}
