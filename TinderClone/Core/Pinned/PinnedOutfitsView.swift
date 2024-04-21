//
//  PinnedOutfitsView.swift
//  TinderClone
//
//  Created by Samantha Su on 4/5/24.
//

import SwiftUI

struct PinnedOutfitsView: View {
    
    @EnvironmentObject var contentViewModel: ContentViewModel
        
        // Calculate the columns
        private func columnImages(column: Int) -> [String] {
            let indices = stride(from: column, to: contentViewModel.likedCardsModels.count, by: 2)
            return indices.map { index in
                contentViewModel.likedCardsModels[index].user.profileImageURL.first ?? ""
            }
        }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(0..<2, id: \.self) { column in
                    VStack(spacing: 16) {
                        ForEach(columnImages(column: column), id: \.self) { imageUrl in
                            Image(imageUrl)
                                .resizable()
                                .scaledToFill()
                                .frame(width: (UIScreen.main.bounds.width / 2) - 20) // Set width dynamically and max height to 300
                                .frame(maxHeight: 300)
                                .clipped()
                                .cornerRadius(15)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct PinnedOutfitsView_Previews: PreviewProvider {
    static var previews: some View {
        PinnedOutfitsView()
            .environmentObject(ContentViewModel.mockSavedOutfits) // Make sure to provide a mock or an actual instance
    }
}
