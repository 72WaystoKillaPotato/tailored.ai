//
//  User.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import Foundation

struct Outfit: Identifiable, Hashable, Codable {
    let id: String
    let description: String
    var outfitURL: [String]
}
