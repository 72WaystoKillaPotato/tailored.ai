//
//  CardService.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import Foundation

struct CardService {
    
    func fetchCardModels(in categories: [String]) async throws -> [CardModel] {

        var outfits = try await fetchImageUrls(for: 30, in: categories)
        print("GOT OUTFITS")
        
        var outfitsToRemoveIndices: [Int] = []

//        let mockOutfits = MockData.users  // get outfit
        
        for (i, var outfit) in outfits.enumerated() {
            guard let url = URL(string: outfit.outfitURL[0]) else {
                throw URLError(.badURL)
            }
            
            let sanitizedFileName = sanitizeFileName(outfit.outfitURL[0])
            outfit.outfitURL[0] = sanitizedFileName
            outfits[i] = outfit
            
            do {
                let imageData = try await downloadImageData(from: url)
                // Image data downloaded successfully
                print("Image data downloaded successfully: \(url)")
                // You can now use imageData to create UIImage or save it to documents directory
                let _ = saveImageToDocumentsDirectory(imageData: imageData, fileName: outfit.outfitURL[0])
            } catch {
                // Error downloading image data
                print("Error downloading image data: \(url)")
                outfitsToRemoveIndices.append(i)
            }
        }
        
        // Remove outfits with errors after the loop has finished
        for index in outfitsToRemoveIndices.reversed() {
            outfits.remove(at: index)
        }
        print("Outfits after santizing: \(outfits)")
        return outfits.map({ CardModel(user: $0) })
    }

    
//    let baseApiUrl = "http://127.0.0.1:5000" // Replace with your actual server IP and port
    let baseApiUrl = "https://6904-2607-f470-6-1001-d1d6-6ed7-3538-bcc4.ngrok-free.app"
    
    func fetchImageUrls(for num: Int, in categories: [String] = []) async throws -> [Outfit] {
        // Construct the URL for the Flask API endpoint
        let apiUrl = baseApiUrl + "/images/\(num)"
        
        // Construct the URL components for the Flask API endpoint
        var apiUrlComponents = URLComponents(string: apiUrl)!

        var queryItems: [URLQueryItem] = []

        // Loop through the list and create a URL query item for each string
        for category in categories {
            let queryItem = URLQueryItem(name: "category", value: category)
            queryItems.append(queryItem)
        }
        
        // Add query parameters
        apiUrlComponents.queryItems = queryItems
        
        // Create a URL object from the API URL string
        guard let url = apiUrlComponents.url else {
            throw URLError(.badURL)
        }
        
        // Perform the URL request and get the data
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode the JSON data into an array of Outfit structs
        let outfits = try JSONDecoder().decode([Outfit].self, from: data)
        
        // Return the array of Outfit structs
        return outfits
    }
    
    func downloadImageData(from imageURL: URL) async throws -> Data {
        // Create a URLSession
        let session = URLSession.shared
        
        // Create a URLRequest
        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"
        
        // Perform the data task asynchronously
        let (data, response) = try await session.data(for: request)
        
        // Check if response is valid and data is present
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // Image data downloaded successfully
        return data
    }
    
//    func downloadImageData(from imageURL: URL, completion: @escaping (Data?) -> Void) {
//        // Create a URLSession
//        let session = URLSession.shared
//        
//        // Create a data task to download the image data
//        let task = session.dataTask(with: imageURL) { (data, response, error) in
//            // Check for errors
//            if let error = error {
//                print("Error downloading image data: \(error)")
//                completion(nil)
//                return
//            }
//            
//            // Check if response is valid and data is present
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode),
//                  let imageData = data else {
//                print("Invalid response or no data received")
//                completion(nil)
//                return
//            }
//            
//            // Image data downloaded successfully
//            completion(imageData)
//        }
//        
//        // Start the data task
//        task.resume()
//    }
    
    func sanitizeFileName(_ fileName: String) -> String {
        let invalidCharacters = CharacterSet(charactersIn: "/:")
        return fileName.components(separatedBy: invalidCharacters).joined(separator: "")
    }
    
    func saveImageToDocumentsDirectory(imageData: Data, fileName: String) -> URL? {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            try imageData.write(to: fileURL)
            print("Successfully saved image to documents directory! Path=\(fileName)")
            return fileURL
        } catch {
            print("Error saving image to documents directory: \(error)")
            return nil
        }
    }
}
