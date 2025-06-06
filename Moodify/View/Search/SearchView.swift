//
//  SearchView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/31/25.
//

import SwiftUI

struct SearchView: View {
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
            
            TextField("Enter Song Title", text: $searchedTrack)
                .frame(width: 350)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    searchViewModel.search(query: searchedTrack) { success in
                        if success {
                            print("success")
                        }
                    }
                }
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(searchViewModel.searchedTracks, id: \.id) { track in
                        SearchedTrackCell(searchedTrack: track)
                    }
                }
            }
            .padding(.top, 10)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top, 20)
    }
}

#Preview {
    SearchView()
}
