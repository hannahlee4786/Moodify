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
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                    .padding(.trailing, 4)
                
                Text("username")
                    .font(.title2)

                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "trash")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 10)
                        .foregroundColor(.red)
                }
            }
            .padding(.leading, 10)
            .padding(.top, 40)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "rectangle")
                .resizable()
                .frame(width: 350, height: 350)
                .aspectRatio(contentMode: .fill)
            
            HStack {
                Text("caption")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title3)
                Text("🎧")
                    .padding(.trailing, 10)
            }
            
            VStack(spacing: 4) {
                Text("Song Title")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("By: Artist")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("June 23, 2025")
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    TestView()
}
