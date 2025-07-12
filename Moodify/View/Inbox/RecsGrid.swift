//
//  RecommendationsGrid.swift
//  Moodify
//
//  Created by Hannah Lee on 7/11/25.
//

import SwiftUI

struct RecsGrid: View {
    @Environment(\.dismiss) var dismiss
    let request: SongRequest
    
    let items: [GridItem] = [
        GridItem(.flexible(minimum: 80)),
        GridItem(.flexible(minimum: 80))
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.black)
                }
                
                Text(request.mood)
                    .font(.title)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            LazyVGrid(columns: items, spacing: 10) {
                ForEach(request.recommendations) { recommendation in
                    RecCell(recommendation: recommendation)
                }
            }
            .padding()
            
            Spacer()
        }
    }
}
