//
//  CardsViewModel.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import Foundation

@MainActor
class CardsViewModel: ObservableObject {
    
    @Published var cardModels = [CardModel]()
    @Published var buttonSwipeAction: SwipeAction?
    
    private let service: CardService
    
    init(service: CardService) {
        self.service = service
        Task { await fetchCardModels() }
    }
    
    func fetchCardModels() async {
        do {
            self.cardModels = try await service.fetchCardModels(in: [])
            print("***FETCHING CARD MODELS***")
        } catch {
            print("DEBUG: Failed to fetch cards with error: \(error)")
        }
    }
    
    func fetchMoreCardModels(in categories: [String]) async {
        do {
            let newCardModels = try await service.fetchCardModels(in: categories)
            // Append the new card models to the existing array
//            self.cardModels.insert(contentsOf: newCardModels, at: 0)
            cardModels.append(contentsOf: newCardModels)
            print("***FETCHING CARD MODELS***")
        } catch {
            print("DEBUG: Failed to fetch cards with error: \(error)")
        }
    }
    
    func removeCard(_ card: CardModel) {
        guard let index = cardModels.firstIndex(where: { $0.id == card.id}) else { return }
        cardModels.remove(at: index)
    }
}
