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
                    .font(.custom("PingFangMO-Regular", size: 20))

                Spacer()
                
                Button {
                } label: {
                    Image("trash")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.red)
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 18)
            .padding(.trailing, 18)
            .padding(.top, 16)
            
            Image(systemName: "square")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
                .foregroundStyle(Color.black)
                .background(Color.black)
                .padding(.leading, 18)
                .padding(.trailing, 18)
                .padding(.top, 10)
                .padding(.bottom, 10)
            
            HStack {
                Button {
                    
                } label: {
                    Image("heartfill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .foregroundStyle(Color.pink)
                }
                .padding(.trailing, 6)
                Button {
                    
                } label: {
                    Image("comment")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .foregroundStyle(Color.black)
                }
                Spacer()
                Text("🫧💗🎧")
                    .padding(6)
            }
            .padding(.leading, 18)
            .padding(.trailing, 18)

            VStack(spacing: 4) {
                Text("caption")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 20))

                Text("Song: ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 16))
                
                Text("By: ")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 16))
                
                Text("date")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom("PingFangMO-Regular", size: 12))

            }
            .padding(.leading, 18)
            .padding(.trailing, 18)
            .padding(.bottom, 16)
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 4)
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    TestView()
}
