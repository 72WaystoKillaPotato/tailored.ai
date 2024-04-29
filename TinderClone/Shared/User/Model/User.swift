//
//  User.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import Foundation

struct User: Identifiable, Hashable, Codable {
    let id: String
    let description: String
    var profileImageURL: [String]
}
