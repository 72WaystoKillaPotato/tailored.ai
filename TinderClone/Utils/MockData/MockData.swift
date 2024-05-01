//
//  MockData.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import Foundation

struct MockData {
    
    static let jsonString = """
[
  {
    "categories": {
      "Dresses": {
        "dress": [
          "zip-up",
          "sheath (dress)",
          "no non-textile material",
          "printed",
          "high waist",
          "below the knee (length)",
          "mermaid"
        ]
      },
      "Footwear": {
        "shoe": []
      },
      "Miscellaneous": {
        "neckline": [
          "scoop (neck)"
        ],
        "sleeve": [
          "sleeveless",
          "cap (sleeve)"
        ]
      }
    },
    "description": "",
    "id": "22998",
    "outfitURL": [
      "https://farm2.staticflickr.com/1936/8611026817_9d9d76ced7_o.jpg"
    ]
  },
  {
    "categories": {
      "Accessories": {
        "watch": []
      },
      "Bottoms": {
        "pants": [
          "no special manufacturing technique",
          "plain (pattern)",
          "normal waist",
          "leggings",
          "no non-textile material",
          "regular (fit)",
          "maxi (length)",
          "symmetrical",
          "peg"
        ]
      },
      "Footwear": {
        "shoe": [],
        "sock": []
      },
      "Miscellaneous": {
        "neckline": [
          "straight across (neck)"
        ]
      },
      "Tops": {
        "sweatshirt": [
          "plain (pattern)",
          "no special manufacturing technique",
          "normal waist",
          "above-the-hip (length)",
          "no non-textile material",
          "tight (fit)",
          "symmetrical",
          "camisole"
        ],
        "t-shirt": [
          "plain (pattern)",
          "no special manufacturing technique",
          "normal waist",
          "above-the-hip (length)",
          "no non-textile material",
          "tight (fit)",
          "symmetrical",
          "camisole"
        ],
        "top": [
          "plain (pattern)",
          "no special manufacturing technique",
          "normal waist",
          "above-the-hip (length)",
          "no non-textile material",
          "tight (fit)",
          "symmetrical",
          "camisole"
        ]
      }
    },
    "description": "",
    "id": "20661",
    "outfitURL": [
      "https://farm3.staticflickr.com/2806/34064949146_2a676e6c0f_n.jpg"
    ]
  },
  {
    "categories": {
      "Accessories": {
        "hat": [],
        "scarf": []
      },
      "Bottoms": {
        "skirt": [
          "straight",
          "sheath (skirt)",
          "no non-textile material",
          "high waist",
          "ruched",
          "plain (pattern)"
        ]
      },
      "Miscellaneous": {
        "sleeve": [
          "wrist-length"
        ],
        "zipper": []
      },
      "Tops": {
        "jacket": [
          "crop (jacket)",
          "zip-up",
          "no non-textile material",
          "above-the-hip (length)",
          "symmetrical",
          "lining",
          "plain (pattern)"
        ],
        "sweatshirt": [],
        "t-shirt": [],
        "top": []
      }
    },
    "description": "",
    "id": "22876",
    "outfitURL": [
      "https://farm2.staticflickr.com/1936/21455874240_9d9d76ced7_o.jpg"
    ]
  },
  {
    "categories": {
      "Bottoms": {
        "pants": [
          "straight",
          "jeans",
          "no non-textile material",
          "maxi (length)",
          "no special manufacturing technique",
          "plain (pattern)"
        ]
      },
      "Footwear": {
        "shoe": []
      },
      "Miscellaneous": {
        "collar": [],
        "pocket": [
          "cargo (pocket)"
        ],
        "sleeve": [
          "wrist-length",
          "set-in sleeve"
        ],
        "zipper": []
      },
      "Outerwear": {
        "coat": [
          "zip-up",
          "no non-textile material",
          "symmetrical",
          "mini (length)",
          "lining",
          "plain (pattern)"
        ]
      },
      "Tops": {
        "blouse": [
          "single breasted",
          "check",
          "no non-textile material",
          "regular (fit)",
          "printed",
          "symmetrical",
          "hip (length)"
        ],
        "shirt": [
          "single breasted",
          "check",
          "no non-textile material",
          "regular (fit)",
          "printed",
          "symmetrical",
          "hip (length)"
        ]
      }
    },
    "description": "",
    "id": "28835",
    "outfitURL": [
      "https://farm8.staticflickr.com/7358/12498524165_1108d2785e_n.jpg"
    ]
  }
]
"""
    
    
    static func loadUsers() -> [Outfit] {
            guard let jsonData = jsonString.data(using: .utf8) else {
                fatalError("Failed to convert JSON string to data")
            }

            do {
                let decoder = JSONDecoder()
                let outfits = try decoder.decode([Outfit].self, from: jsonData)
                return outfits
            } catch {
                fatalError("Error decoding JSON: \(error)")
            }
        }

    static let users: [Outfit] = loadUsers()
}
