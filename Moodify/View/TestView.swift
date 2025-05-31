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
            Image(systemName: "play.circle")
            
            Text("Title: I Like Me Better")
            
            Text("Album: I met you when I was 18.")

            Text("Artist: Lauv")
        }
    }
}

#Preview {
    TestView()
}
