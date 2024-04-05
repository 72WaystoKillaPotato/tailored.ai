//
//  TabView.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 1 // Default to the tab with tag 1
    var body: some View {
        TabView (selection: $selectedTab){
            PinnedOutfitsView()
                .tabItem { Image(systemName: "pin") }
                .tag(0)
            
            CardStackView()
                .tabItem { Image(systemName: "heart") }
                .tag(1)
            
            Text("Profile page")
                .tabItem { Image(systemName: "person") }
                .tag(2)
        }
        .tint(.primary)
    }
}

#Preview {
    TabBarView()
}
