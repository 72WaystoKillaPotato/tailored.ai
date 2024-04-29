//
//  PhotoView.swift
//  TinderClone
//
//  Created by 陈昱桦 on 4/28/24.
//

import SwiftUI
import Foundation

struct PhotoView: View {
    @State private var showingImagePicker = false
    @State private var selfieImage: UIImage?
    @State private var clothingImage: UIImage?
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    @State private var currentSelection: String = ""
    @State private var isProcessing = false

    var body: some View {
        NavigationView {
            VStack {
                Button("Process Images") {
                    isProcessing = true
                    startProcessingImages()
                }
                .disabled(selfieImage == nil || clothingImage == nil)
                .padding()
                .background(Color("colors/blue"))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding()

                if isProcessing {
                    ProgressView("Processing...")
                } else if let processedImage = processedImage {
                    Image(uiImage: processedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                
                if let selfieImage = selfieImage {
                    Image(uiImage: selfieImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .padding()
                } else {
                    Button("Take Selfie") {
                        currentSelection = "Selfie"
                        showingImagePicker = true
                    }
                    .padding()
                    .background(Color("colors/blue"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                }
                
                if let clothingImage = clothingImage {
                    Image(uiImage: clothingImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .padding()
                } else {
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
            }
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
        }
    }

    // handle image processing
    func loadImage() {
        guard let inputImage = inputImage else { return }
        guard let imageData = inputImage.jpegData(compressionQuality: 0.8) else { return }
        
        let url = URL(string: "API/upload")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer TOKEN", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.uploadTask(with: request, from: imageData) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Image uploaded successfully")
            } else {
                print("Failed to upload image")
            }
        }
        task.resume()
    }
    
    // downloads the processed image
    func downloadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error downloading processed image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.processedImage = UIImage(data: data)
            }
        }
        task.resume()
    }
    
    func startProcessingImages() {
            guard let selfieData = selfieImage?.jpegData(compressionQuality: 0.8),
                  let clothingData = clothingImage?.jpegData(compressionQuality: 0.8) else { return }

            // Combine both image data and send to backend
            // Simulate processing delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.processedImage = UIImage(systemName: "checkmark.circle.fill") // Placeholder for processed result
                self.isProcessing = false
            }
        }
}


#Preview {
    PhotoView()
}
