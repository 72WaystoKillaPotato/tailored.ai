//
//  ContentViewModel.swift
//  TinderClone
//
//  Created by Samantha Su on 4/5/24.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var likedCardsModels: [CardModel] = []  { // Add this line to store liked models
        didSet {
            saveLikedCardsModels()
        }
    }
    
    @Published var filterModel: FilterModel = FilterModel()
    
    @Published var likedCategories: [String] = []
    
    
    private let plistFile = "LikedCards.plist"
    
    init() {
        loadLikedCardsModels()
    }
    
    private func saveLikedCardsModels() {
        guard let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(plistFile) else {
            return
        }
        
        do {
            let plistData = try PropertyListEncoder().encode(likedCardsModels)
            try plistData.write(to: plistURL)
        } catch {
            print("Error saving likedCardsModels: \(error)")
        }
    }
    
    private func loadLikedCardsModels() {
        guard let plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(plistFile) else {
            return
        }
        do {
            let plistData = try Data(contentsOf: plistURL)
            likedCardsModels = try PropertyListDecoder().decode([CardModel].self, from: plistData)
        } catch {
            print("Error Loading likedCardsModels: \(error)")
        }
    }
    
    static var mockSavedOutfits: ContentViewModel {
        let model = ContentViewModel()
        // Populate the model with test data
        let users: [Outfit] = [
            .init(
                id: "39708",
                description: "",
                outfitURL: ["https://farm6.staticflickr.com/5350/9907922113_d507ed7f2e_n.jpg"],
                categories: [
                    "Dresses": [
                        "dress": [
                            "no special manufacturing technique",
                            "normal waist",
                            "stripe",
                            "no non-textile material",
                            "above-the-knee (length)",
                            "pencil",
                            "symmetrical",
                            "zip-up",
                            "bodycon (dress)"
                        ]
                    ],
                    "Miscellaneous": [
                        "neckline": ["off-the-shoulder"],
                        "sleeve": ["dropped-shoulder sleeve", "short (length)"],
                        "zipper": []
                    ]
                ]
            ),
            .init(
                id: "47679",
                description: "",
                outfitURL: ["https://farm3.staticflickr.com/2485/3691568587_b9e3d403d5_m.jpg"],
                categories: [
                    "Miscellaneous": [
                        "collar": ["regular (collar)"],
                        "sleeve": ["short (length)", "set-in sleeve"]
                    ],
                    "Tops": [
                        "blouse": [
                            "above-the-hip (length)",
                            "no special manufacturing technique",
                            "normal waist",
                            "no non-textile material",
                            "stripe",
                            "regular (fit)",
                            "single breasted",
                            "symmetrical"
                        ],
                        "shirt": [
                            "above-the-hip (length)",
                            "no special manufacturing technique",
                            "normal waist",
                            "no non-textile material",
                            "stripe",
                            "regular (fit)",
                            "single breasted",
                            "symmetrical"
                        ]
                    ]
                ]
            ),
            .init(
                id: "23413",
                description: "",
                outfitURL: ["https://farm6.staticflickr.com/5691/23622753682_e637161274_n.jpg"],
                categories: [
                    "Accessories": [
                        "bag": [],
                        "wallet": [],
                        "watch": []
                    ],
                    "Bottoms": [
                        "shorts": [
                            "regular (fit)",
                            "symmetrical",
                            "no special manufacturing technique",
                            "mini (length)"
                        ]
                    ],
                    "Miscellaneous": [
                        "neckline": ["scoop (neck)"],
                        "pocket": ["curved (pocket)"],
                        "sleeve": ["set-in sleeve", "three quarter (length)"]
                    ],
                    "Tops": [
                        "sweatshirt": [
                            "plain (pattern)",
                            "no non-textile material"
                        ],
                        "t-shirt": [
                            "plain (pattern)",
                            "no non-textile material"
                        ],
                        "top": [
                            "plain (pattern)",
                            "no non-textile material"
                        ]
                    ]
                ]
            ),
        ]
        model.likedCardsModels = users.map { CardModel(user: $0) }
        return model
    }
}
