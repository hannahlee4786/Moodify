//
//  SearchView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/31/25.
//

import SwiftUI

struct SearchTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .stroke(Color.black, lineWidth: 1)
        )
        .background(Color.white)
    }
}

struct SearchView: View {
    @Binding var selectedTrack: TrackObject?
    @Environment(\.dismiss) var dismiss
    @StateObject var searchViewModel = SearchViewModel()
    @State private var searchedTrack = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Image("searchheader")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 48)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 10)
            
            TextField("e n t e r   s o n g / a r t i s t", text: $searchedTrack)
                .frame(width: 350)
                .textFieldStyle(SearchTextFieldStyle())
                .onSubmit {
                    searchViewModel.search(query: searchedTrack) { success in
                        if success {
                            print("Successfully displayed searched tracks.")
                        }
                    }
                }
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(searchViewModel.searchedTracks, id: \.id) { track in
                        SearchedTrackCell(searchedTrack: track) {
                            selectedTrack = track
                            dismiss()
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 20)
        .padding(.horizontal, 10)
        .background(Color(red: 242/255, green: 223/255, blue: 206/255))
    }
}
