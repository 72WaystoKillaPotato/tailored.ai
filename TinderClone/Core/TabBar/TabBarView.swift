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
        NavigationStack{
            TabView(selection: $selectedTab) {
                PhotoView()
                
                    .tabItem {
                        Label("Fit Room", systemImage: "camera")
                    }
                    .tag(3)
                
                PinnedOutfitsView()
                
                    .tabItem {
                        Label("Outfits", systemImage: "pin")
                    }
                    .tag(0)
                
                CardStackView()
                
                    .tabItem {
                        Label("Exlore", systemImage: "heart")
                    }
                    .tag(1)
                
                UserProfileView()
                
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(2)
            }
            .tint(.primary)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                        Image("inAppIcon").resizable()
                            .scaledToFit()
                    }
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(ContentViewModel.mockSavedOutfits) // Similar setup needed in actual app usage
    }
}
