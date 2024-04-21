//
//  ContentViewModel.swift
//  TinderClone
//
//  Created by Samantha Su on 4/5/24.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var likedCardsModels: [CardModel] = [] // Add this line to store liked models
    
    static var mockSavedOutfits: ContentViewModel {
        let model = ContentViewModel()
        // Populate the model with test data
        let users: [User] = [
            .init(
                id: NSUUID().uuidString,
                description: "1",
                profileImageURL: ["outfits/1"]
            ),
            .init(
                id: NSUUID().uuidString,
                description: "2",
                profileImageURL: ["outfits/2"]
            ),
            .init(
                id: NSUUID().uuidString,
                description: "3",
                profileImageURL: ["outfits/3"]
            )
        ]
        model.likedCardsModels = users.map({ CardModel(user: $0) })
        return model
    }
}