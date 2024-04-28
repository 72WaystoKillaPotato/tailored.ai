//
//  PhotoView.swift
//  TinderClone
//
//  Created by 陈昱桦 on 4/28/24.
//

import SwiftUI

struct PhotoView: View {
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentSelection: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Button("Take Selfie") {
                    currentSelection = "Selfie"
                    showingImagePicker = true
                }
                .padding()
                .background(Color("colors/blue"))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
                
                Button("Choose Clothing") {
                    currentSelection = "Clothing"
                    showingImagePicker = true
                }
                .padding()
                .background(Color("colors/blue"))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()
                
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
    }

    func loadImage() {
        // Here you can handle the image processing
    }
}


#Preview {
    PhotoView()
}
