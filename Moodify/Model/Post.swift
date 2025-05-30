//
//  Post.swift
//  Moodify
//
//  Created by Hannah Lee on 5/5/25.
//

struct Post: Identifiable, Codable {
    let id: String
    let caption: String
    let imageURL: String
}
