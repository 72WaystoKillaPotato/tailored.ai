//
//  TabView.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 1  // Default to the tab with tag 1

    var body: some View {
        TabView(selection: $selectedTab) {
                PinnedOutfitsView()
                   
            .tabItem {
                Label("Outfits", systemImage: "pin")
            }
            .tag(0)
            
            
                CardStackView()
                    
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }
            .tag(1)
            
            
                Text("Profile Page Content")
                    
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            .tag(2)
        }
        .tint(.primary)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(ContentViewModel.mockSavedOutfits) // Similar setup needed in actual app usage
    }
}
