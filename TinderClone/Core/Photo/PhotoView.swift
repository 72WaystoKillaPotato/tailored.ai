//
//  PhotoView.swift
//  TinderClone
//
//  Created by 陈昱桦 on 4/28/24.
//

import SwiftUI
import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

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
                    uploadImages()
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
        guard let inputImage = inputImage else { return }
        if currentSelection == "Selfie" {
            selfieImage = inputImage
        } else if currentSelection == "Clothing" {
            clothingImage = inputImage
        }
    }

    func uploadImages() {
        guard let selfieData = selfieImage?.jpegData(compressionQuality: 0.8),
              let clothingData = clothingImage?.jpegData(compressionQuality: 0.8) else { return }

        let url = URL(string: "https://158.130.50.47:3030/upload")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append(convertFileData(fieldName: "selfie", fileName: "selfie.jpg", mimeType: "image/jpeg", fileData: selfieData, using: boundary))
        body.append(convertFileData(fieldName: "clothing", fileName: "clothing.jpg", mimeType: "image/jpeg", fileData: clothingData, using: boundary))
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                isProcessing = false
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("HTTP Error: \(response.debugDescription)")
                isProcessing = false
                return
            }
            DispatchQueue.main.async {
                self.processedImage = UIImage(data: data) // Assuming the server response with the image directly
                isProcessing = false
            }
        }
        task.resume()
    }

    private func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        var data = Data()

        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.append("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.append("\r\n")

        return data
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
