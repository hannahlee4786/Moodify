//
//  SearchView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/31/25.
//

import SwiftUI

struct SearchView: View {
    @Binding var selectedTrack: TrackObject?
    @Environment(\.dismiss) var dismiss
    @StateObject var searchViewModel = SearchViewModel()
    @State private var searchedTrack = ""
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text("Search")
                    .font(.largeTitle)
                    .padding(.leading, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            TextField("Enter Song Title/Artist", text: $searchedTrack)
                .frame(width: 350)
                .textFieldStyle(.roundedBorder)
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
            .padding(.top, 10)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 20)
    }
}
