//
//  TinderCloneApp.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import SwiftUI

@main
struct TinderCloneApp: App {
    
    @StateObject var contentViewModel = ContentViewModel()

    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environmentObject(ContentViewModel()) // Add the shared ViewModel to the environment
        }
    }
}
