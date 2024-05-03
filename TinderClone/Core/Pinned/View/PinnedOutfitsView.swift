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
    @State private var showingFilterView = false // State to manage the display of the filter view
//    @State private var selectedImage: ImageItem?
    @State private var selectedImage: CardModel?
    @State private var filteredCardModels: [CardModel] = []
    
    @ObservedObject var filterModel: FilterModel = FilterModel()
    
    private func filteredImages() -> [CardModel] {
//        let selectedFilters = contentViewModel.filterModel.getSelectedFilters()
        let selectedFilters = filterModel.getSelectedFilters()
        print("SelectedFilters: \(selectedFilters)")
        
        if (selectedFilters.isEmpty) {
            return contentViewModel.likedCardsModels
        }
        
        // Filter the images based on the selected filters
        let filteredModels = contentViewModel.likedCardsModels.filter { cardModel in
            for (category, attribute) in selectedFilters {
                if cardModel.user.categories[category]?[attribute.lowercased()] == nil {
                    return false
                }
            }
            return true
        }
        
        // Get the image URLs from the filtered models
        return filteredModels
    }
        
    // Calculate the columns
//    private func columnImages(column: Int) -> [String] {
    private func columnImages(column: Int) -> [CardModel] {
        let filteredCardModels = filteredImages()
        let indices = stride(from: column, to: filteredCardModels.count, by: 2)
        return indices.map { index in
//            filteredCardModels[index].user.outfitURL.first ?? ""
            filteredCardModels[index]
        }
//        let indices = stride(from: column, to: contentViewModel.likedCardsModels.count, by: 2)
//        return indices.map { index in
//            contentViewModel.likedCardsModels[index].user.outfitURL.first ?? ""
//        }
    }

    var body: some View {
        VStack{
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(0..<2, id: \.self) { column in
                        VStack(spacing: 16) {
//                            ForEach(columnImages(column: column), id: \.self) { imageUrl in
//                                if let image = loadImageFromDocumentsDirectory(fileName: imageUrl) {
                            ForEach(columnImages(column: column), id: \.self) { cardModel in
                                if let image = loadImageFromDocumentsDirectory(fileName: cardModel.user.outfitURL[0]) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 20) // Set width dynamically and max height to 300
                                        .frame(maxHeight: 300)
                                        .clipped()
                                        .cornerRadius(15)
                                        .onTapGesture {
//                                            selectedImage = ImageItem(url: imageUrl)
                                            selectedImage = cardModel
                                        }
                                } else {
                                    // Placeholder image or some fallback view if the image couldn't be loaded
                                    Image("outfits/3") // Placeholder color
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: (UIScreen.main.bounds.width / 2) - 20) // Set width dynamically and max height to 300
                                        .frame(maxHeight: 300)
                                        .clipped()
                                        .cornerRadius(15)
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
//                    OutfitDetailView(imageUrl: item.url)
                    OutfitDetailView(outfit: item)
                }
            }
            // Add Custom Measurement Button
            Button("Filter",systemImage: "line.3.horizontal.decrease.circle.fill") {
                showingFilterView = true
            }
            .padding()
            .background(Color("colors/blue"))
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding()
            .sheet(isPresented: $showingFilterView) {
                // Assuming FilterView and its viewModel exist and are correctly configured
//                FilterView(viewModel: FilterModel()) // You might need to adjust the viewModel initialization based on your app's architecture
                FilterView(viewModel: filterModel) // You might need to adjust the viewModel initialization based on your app's architecture
            }
        }
        .onAppear {
            filteredCardModels = contentViewModel.likedCardsModels
        }
//        .onChange(of: contentViewModel.filterModel.selectedFilters) {
        .onChange(of: filterModel.selectedFilters) {
            print("***FILTERING***")
            filteredCardModels = filteredImages()
        }
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

struct PinnedOutfitsView_Previews: PreviewProvider {
    static var previews: some View {
        PinnedOutfitsView()
            .environmentObject(ContentViewModel.mockSavedOutfits) // Make sure to provide a mock or an actual instance
    }
}
