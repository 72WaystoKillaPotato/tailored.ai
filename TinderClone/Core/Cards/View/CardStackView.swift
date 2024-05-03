//
//  CardStackView.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import SwiftUI

struct CardStackView: View {
    
    @StateObject var viewModel = CardsViewModel(service: CardService())
    
    private func checkAndFetchMoreModelsIfNeeded() {
        guard viewModel.cardModels.count == 20 || viewModel.cardModels.count == 10 || viewModel.cardModels.count == 0 else {
            // If there are already 10 or more card models, no need to fetch more
            return
        }
        
        // Fetch more card models
        Task {
            await viewModel.fetchMoreCardModels()
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                ZStack {
                    Text("Loading more outfits!").font(.title3).fontWeight(.medium).foregroundColor(Color(UIColor.systemGray)).multilineTextAlignment(.center)
                    ForEach(viewModel.cardModels.reversed()) { card in
                        CardView(viewModel: viewModel, model: card)
                            
                    }
                }
                
                if !viewModel.cardModels.isEmpty {
                    SwipeActionButtonsView(viewModel: viewModel)
                }
            }
        }
        .onChange(of: viewModel.cardModels.count) {
            // Fetch more card models when the view appears
            print("IMAGE COUNT: \(viewModel.cardModels.count)")
            checkAndFetchMoreModelsIfNeeded()
        }
    }
        
}

#Preview {
    CardStackView()
}
