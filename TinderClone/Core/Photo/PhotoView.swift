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
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
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
}


#Preview {
    PhotoView()
}
