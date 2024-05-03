//
//  FilterView.swift
//  TinderClone
//
//  Created by Samantha Su on 5/1/24.
//

import SwiftUI

struct FilterView: View {
    @ObservedObject var viewModel: FilterModel

    let categories: [String: [String]] = [
        "Tops": ["Shirt", "Blouse", "T-shirt", "Sweatshirt", "Sweater", "Cardigan", "Jacket", "Vest"],
        "Dresses": ["Dress", "Jumpsuit"],
        "Outerwear": ["Coat", "Cape"],
        "Bottoms": ["Pants", "Shorts", "Skirt"],
        "Accessories": ["Glasses", "Hat", "Headband", "Head Covering", "Hair Accessory", "Tie", "Glove", "Watch", "Belt", "Leg warmer", "Bag", "Wallet", "Tights", "Stockings", "Scarf", "Umbrella"],
        "Footwear": ["Shoe", "Sock"],
        "Miscellaneous": ["Hood", "Collar", "Lapel", "Epaulette", "Sleeve", "Pocket", "Neckline", "Buckle", "Zipper", "Applique", "Bead", "Bow", "Flower", "Fringe", "Ribbon", "Rivet", "Ruffle", "Sequin", "Tassel"]
    ]
    let categoryOrder: [String] = [
        "Tops", "Bottoms", "Dresses", "Outerwear", "Accessories", "Footwear", "Miscellaneous"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(categoryOrder, id: \.self) { category in
                        VStack(alignment: .leading) {
                            Text(category)
                                .font(.headline)
                                .padding(.vertical, 10)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(categories[category]!, id: \.self) { attribute in
                                        Button(action: {
                                            viewModel.toggleFilter(category: category, attribute: attribute)
                                        }) {
                                            Text(attribute)
                                                .padding()
                                                .background(viewModel.isFilterSelected(category: category, attribute: attribute) ? Color("colors/yellow") : Color("colors/lightBrown"))
                                                .foregroundColor(.black)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .navigationTitle("Filter")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button("Clear") {
                            viewModel.selectedFilters.removeAll()
                        }
                        .foregroundColor(Color("colors/blue"))
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Done") {
                            // TODO : Handle Done action, such as applying filters and closing the view
                            print("FILTERS: \(viewModel.selectedFilters)")
                        }
                        .foregroundColor(Color("colors/blue"))
                    }
                }
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(viewModel: FilterModel())
    }
}

