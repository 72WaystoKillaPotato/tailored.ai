//
//  TabView.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            CardStackView()
                .tabItem { Image(systemName: "flame") }
                .tag(0)
            
            Text("searching page")
                .tabItem { Image(systemName: "magnifyingglass") }
                .tag(1)
            
            Text("Messages page")
                .tabItem { Image(systemName: "bubble") }
                .tag(2)
            
            Text("Profile page")
                .tabItem { Image(systemName: "person") }
                .tag(3)
        }
        .tint(.primary)
    }
}

#Preview {
    TabBarView()
}
