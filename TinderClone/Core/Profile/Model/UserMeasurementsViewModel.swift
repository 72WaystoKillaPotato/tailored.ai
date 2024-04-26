//
//  UserMeasurementsViewModel.swift
//  TinderClone
//
//  Created by Samantha Su on 4/25/24.
//

import SwiftUI
import AdvancedList

class UserMeasurementsViewModel: ObservableObject {
    @Published var measurements: [String: String] = [
        "Waist": "30 inches",
        "Height": "165 cm",
        "Weight": "100 lbs",
        "Arm Length": "34 inches",
        "Hips": "",
        "Bust": "",
        "Neck": "",
        "Shoulder": "",
        "Back Width": "",
        "Inseam": "",
        "Thigh": "",
        "Knee": "",
        "Leg": "",
    ]
    @Published var searchText = ""

    // Computed property that filters measurements based on search text
    var filteredMeasurements: [Measurement] {
        let sortedMeasurements = measurements.sorted { first, second in
            // If searchText is empty, prioritize empty values higher, otherwise sort by keys
            if searchText.isEmpty {
                if first.value.isEmpty, second.value.isEmpty {
                    return first.key < second.key  // Both are empty, sort by key
                }
                return first.value.isEmpty && !second.value.isEmpty  // Empty values come first
            } else {
                return first.key.localizedCaseInsensitiveContains(searchText) ||
                       first.value.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Map to Measurement objects for the list
        return sortedMeasurements.map { Measurement(id: $0.key, value: $0.value) }
    }
}
