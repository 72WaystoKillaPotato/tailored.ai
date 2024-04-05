//
//  PinnedOutfitsView.swift
//  TinderClone
//
//  Created by Samantha Su on 4/5/24.
//

import SwiftUI

struct PinnedOutfitsView: View {
    
    @EnvironmentObject var contentViewModel: ContentViewModel

    var body: some View {
            VStack {
                // Iterate over each CardModel in likedCardsModels
                ForEach(contentViewModel.likedCardsModels, id: \.id) { cardModel in
                    // Now create a sub VStack for each user's images
                    VStack(alignment: .leading, spacing: 10) {
                        // Optionally, display the user's description or any other info
                        Text(cardModel.user.description)
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        // Iterate over each image URL in the user's profileImageURL
                        ForEach(cardModel.user.profileImageURL, id: \.self) { imageName in
                            Image(imageName) // Assuming these are image names in your assets
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom, 20) // Add some padding below each user's stack of images
                }
            }
            .padding() // Add padding around the entire VStack
        }
}

#Preview {
    PinnedOutfitsView()
}
