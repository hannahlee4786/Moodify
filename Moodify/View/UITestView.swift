//
//  SwiftUIView.swift
//  Moodify
//
//  Created by Hannah Lee on 7/12/25.
//

import SwiftUI

struct UITestView: View {
    @State var searchedTrack = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Image("searchheader")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 48)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            
            TextField(" e n t e r   s o n g / a r t i s t", text: $searchedTrack)
                .frame(width: 350)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
//                    searchViewModel.search(query: searchedTrack) { success in
//                        if success {
//                            print("Successfully displayed searched tracks.")
//                        }
//                    }
                }
            
            ScrollView {
                VStack(spacing: 12) {
//                    ForEach(searchViewModel.searchedTracks, id: \.id) { track in
//                        SearchedTrackCell(searchedTrack: track) {
//                            selectedTrack = track
//                            dismiss()
//                        }
//                    }
                }
            }
            .padding(.top, 10)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 20)
        .padding(.horizontal, 10)
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
    }
}

#Preview {
    UITestView()
}
