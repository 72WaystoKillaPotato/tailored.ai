//
//  ContentViewModel.swift
//  TinderClone
//
//  Created by Samantha Su on 4/5/24.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var likedCardsModels: [CardModel] = [] // Add this line to store liked models
}
