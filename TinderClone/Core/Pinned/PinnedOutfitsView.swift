//
//  PinnedOutfitsView.swift
//  TinderClone
//
//  Created by Samantha Su on 4/5/24.
//

import SwiftUI

// Define a custom struct to hold the image URL
struct ImageItem: Identifiable {
    let id = UUID() // Provide a unique ID
    let url: String
}

struct PinnedOutfitsView: View {
    
    @EnvironmentObject var contentViewModel: ContentViewModel
    @State private var selectedImage: ImageItem?

        
    // Calculate the columns
    private func columnImages(column: Int) -> [String] {
        let indices = stride(from: column, to: contentViewModel.likedCardsModels.count, by: 2)
        return indices.map { index in
            contentViewModel.likedCardsModels[index].user.outfitURL.first ?? ""
        }
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack(alignment: .top, spacing: 16) {
                ForEach(0..<2, id: \.self) { column in
                    VStack(spacing: 16) {
                        ForEach(columnImages(column: column), id: \.self) { imageUrl in
//                            Image(imageUrl) // Assuming you have a way to load images from URL strings
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: (UIScreen.main.bounds.width / 2) - 20) // Set width dynamically and max height to 300
//                                .frame(maxHeight: 300)
//                                .clipped()
//                                .cornerRadius(15)
//                                .onTapGesture {
//                                    selectedImage = ImageItem(url: imageUrl)
//                                }
                            if let image = loadImageFromDocumentsDirectory(fileName: imageUrl) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: (UIScreen.main.bounds.width / 2) - 20) // Set width dynamically and max height to 300
                                    .frame(maxHeight: 300)
                                    .clipped()
                                    .cornerRadius(15)
                                    .onTapGesture {
                                        selectedImage = ImageItem(url: imageUrl)
                                    }
                            } else {
                                // Placeholder image or some fallback view if the image couldn't be loaded
                                Color.gray // Placeholder color
                                    .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                                    .overlay {
                                        Text("Image not found")
                                            .foregroundColor(.white)
                                    }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .sheet(item: $selectedImage) { item in
                OutfitDetailView(imageUrl: item.url)
            }
        }
    }
}

struct PinnedOutfitsView_Previews: PreviewProvider {
    static var previews: some View {
        PinnedOutfitsView()
            .environmentObject(ContentViewModel.mockSavedOutfits) // Make sure to provide a mock or an actual instance
    }
}

private func loadImageFromDocumentsDirectory(fileName: String) -> UIImage? {
    print("LOADING DATA: \(fileName)")
    do {
        let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let imageData = try Data(contentsOf: fileURL)
        print("Successfully loaded image from documents directory!")
        return UIImage(data: imageData)
    } catch {
        print("Error loading image from documents directory: \(error)")
        return nil
    }
}
