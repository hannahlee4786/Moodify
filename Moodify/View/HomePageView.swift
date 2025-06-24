//
//  HomePageView.swift
//  Moodify
//
//  Created by Hannah Lee on 5/17/25.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @StateObject var inboxViewModel = InboxViewModel()

    var body: some View {
        Image(systemName: "house.fill")
    }
}
