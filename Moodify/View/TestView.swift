//
//  TestView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/23/25.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        VStack {
            Text("Home ❀")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .font(.largeTitle)
                .padding(.leading, 20)
        }
    }
}

#Preview {
    TestView()
}
