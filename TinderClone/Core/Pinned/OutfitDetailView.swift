//
//  OutfitDetailView.swift
//  TinderClone
//
//  Created by Samantha Su on 4/25/24.
//

import SwiftUI

struct OutfitDetailView: View {
    var imageUrl: String    
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0

    var body: some View {
        GeometryReader { geometry in
            Image(imageUrl) // Make sure to handle image loading correctly
                .resizable()
                .scaledToFit()
                .clipped()
                .cornerRadius(15)
                .frame(width: max(geometry.size.width - 20, 0))
                .frame(maxHeight: max(geometry.size.height - 20, 0))
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .scaleEffect(currentZoom + totalZoom)
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            currentZoom = value.magnification - 1
                        }
                        .onEnded { value in
                            totalZoom += currentZoom
                            currentZoom = 0
                            totalZoom = max(totalZoom, 1)
                        }
                )
                .accessibilityZoomAction { action in
                    if action.direction == .zoomIn {
                        totalZoom += 1
                    } else {
                        totalZoom -= 1
                    }
                }
        }
    }
}

struct OutfitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OutfitDetailView(imageUrl: "outfits/1")
    }
}
