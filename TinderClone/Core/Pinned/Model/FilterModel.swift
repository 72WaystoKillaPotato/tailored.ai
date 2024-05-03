//
//  FilterModel.swift
//  TinderClone
//
//  Created by Samantha Su on 5/1/24.
//
import SwiftUI

class FilterModel: ObservableObject {
    @Published var selectedFilters: [String: String] = [:]
    
    func isFilterSelected(category: String, attribute: String) -> Bool {
        selectedFilters[category] == attribute
    }
    
    func toggleFilter(category: String, attribute: String) {
        if isFilterSelected(category: category, attribute: attribute) {
            selectedFilters.removeValue(forKey: category)
        } else {
            selectedFilters[category] = attribute
        }
        print("Selected Filters: \(selectedFilters)")
    }
    
    func getSelectedFilters() -> [String: String] {
        return selectedFilters
    }
}
