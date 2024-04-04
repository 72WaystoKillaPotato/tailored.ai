//
//  MockData.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import Foundation

struct MockData {
    static let users: [User] = [
        .init(
            id: NSUUID().uuidString,
            fullname: "Ana De Armas",
            age: 35,
            profileImageURLs: ["ana1", "ana2", "ana3"]
        ),
        .init(
            id: NSUUID().uuidString,
            fullname: "Margot Robbie",
            age: 33,
            profileImageURLs: ["margot1", "margot2", "margot3"]
        ),
        .init(
            id: NSUUID().uuidString,
            fullname: "Scarlett Johanson",
            age: 39,
            profileImageURLs: ["johan1", "johan2", "johan3"]
        )
        
        
    ]
}
