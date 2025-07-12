//
//  TestView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/23/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("song title")
            Text("artist")
                .font(.footnote)
            Text("From: username")
                .font(.caption)
        }
    }
}

#Preview {
    TestView()
}
