//
//  CardView.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import SwiftUI
import URLImage

struct CardView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel
    @ObservedObject var viewModel: CardsViewModel
    
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    @State private var currentImageIndex = 0
    @State private var showProfileModal = false
    
    let model: CardModel
    
    // Store loaded images in a dictionary
    @State private var imageCache: [String: UIImage] = [:]
    
    private func loadImageFromDocumentsDirectory(fileName: String) {
        print("LOADING DATA (CardView): \(fileName)")
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            let imageData = try Data(contentsOf: fileURL)
            // Store loaded image in the cache
            if let image = UIImage(data: imageData) {
                imageCache[fileName] = image
            }
        } catch {
            print("Error loading image from documents directory: \(error)")
        }
    }
    
//    // Trigger the fetching of more card models if the remaining number of images is less than 10
//    private func checkAndFetchMoreModelsIfNeeded() {
//        guard viewModel.cardModels.count < 10 else {
//            // If there are already 10 or more card models, no need to fetch more
//            return
//        }
//        
//        // Fetch more card models
//        Task {
//            await viewModel.fetchMoreCardModels()
//        }
//    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
//                Image(user.outfitURL[currentImageIndex])
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
//                    .overlay {
//                        ImageScrollingOverlay(currentImageIndex: $currentImageIndex, imageCount: imageCount)
//                    }l
                    if let image = imageCache[user.outfitURL[0]] {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                            .overlay {
                                ImageScrollingOverlay(currentImageIndex: $currentImageIndex, imageCount: imageCount)
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
                
                SwipeActionIndicatorView(xOffset: $xOffset)

            }
                
            OutfitInfoView(showProfileModal: $showProfileModal, user: user)

        }
//        .fullScreenCover(isPresented: $showProfileModal) {
//            UserProfileView(user: user)
//        }
        .onAppear {
            // Load images from documents directory when the view appears
            loadImageFromDocumentsDirectory(fileName: user.outfitURL[0])
            
//            // Check and fetch more card models if needed
//            print("IMAGE COUNT: \(viewModel.cardModels.count)")
//            checkAndFetchMoreModelsIfNeeded()
        }
        .onReceive(viewModel.$buttonSwipeAction, perform: { action in
            onReceiveSwiperAction(action)
        })
        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
        .clipShape(.rect(cornerRadius: 10))
        .offset(x: xOffset)
        .rotationEffect(.degrees(degrees))
        .animation(.snappy, value: xOffset)
        .gesture(
            DragGesture()
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
        )
    }
}

private extension CardView {
    var user: Outfit {
        return model.user
    }
    
    var imageCount: Int {
        return user.outfitURL.count
    }
}

private extension CardView {
    
    func returnToCenter() {
        xOffset = 0
        degrees = 0
    }
    
    func swipeRight() {
        withAnimation {
            xOffset = 500
            degrees = 12
        } completion: {
            viewModel.removeCard(model)
            contentViewModel.likedCardsModels.append(model)
            print("Liked: \(contentViewModel.likedCardsModels)")
        }
    }
    
    func swipeLeft() {
        withAnimation {
            xOffset = -500
            degrees = -12
        } completion: {
            viewModel.removeCard(model)
            deleteImageFromDocumentsDirectory(filename: model.user.outfitURL[0])
        }
    }
    
    func onReceiveSwiperAction(_ action: SwipeAction?) {
        guard let action else { return }
        
        let topCard = viewModel.cardModels.first
        
        if topCard == model {
            switch action {
            case .reject:
                swipeLeft()
            case .like:
                swipeRight()
            }
        }
    }
}

private extension CardView {
    
    func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value) {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25)
    }
    
    func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
        let width = value.translation.width
        
        if abs(width) <= abs(SizeConstants.screenCutoff) {
            returnToCenter()
            return
        }
        
        if width >= SizeConstants.screenCutoff {
            swipeRight()
        } else {
            swipeLeft()
        }
    }
}

private func deleteImageFromDocumentsDirectory(filename: String) {
    guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return
    }
    
    let fileURL = documentsDirectory.appendingPathComponent(filename)
    
    do {
        try FileManager.default.removeItem(at: fileURL)
        print("Image deleted successfully.")
    } catch {
        print("Error deleting image: \(error.localizedDescription)")
    }
}

#Preview {
    CardView(viewModel: CardsViewModel(service: CardService()),
             model: try! CardModel(from: MockData.users[0] as! Decoder))
}
