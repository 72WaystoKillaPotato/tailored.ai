//
//  UserInfoView.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import SwiftUI

struct OutfitInfoView: View {
    
    @Binding var showProfileModal: Bool
    @State private var isTextExpanded = false
    
    let user: Outfit
    
    var body: some View {
        Button(action: {
            // Toggle the expanded state
            isTextExpanded.toggle()
        }) {
            Text(parseAndFormatAttributes(input: user.categories.description))
                .font(.subheadline)
                .lineLimit(isTextExpanded ? nil : 2) // Conditional line limit
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                )
        }
    }
}

func parseAndFormatAttributes(input: String) -> String {
    // Remove unwanted characters
    let cleanedString = input
        .replacingOccurrences(of: "[", with: "")
        .replacingOccurrences(of: "]", with: "")
        .replacingOccurrences(of: "{", with: "")
        .replacingOccurrences(of: "}", with: "")
        .replacingOccurrences(of: "\"", with: "")
        .replacingOccurrences(of: "(", with: "")
        .replacingOccurrences(of: ")", with: "")

    // Replace colons and clean up commas
    let semiFormattedString = cleanedString.replacingOccurrences(of: ":", with: ",")
        .replacingOccurrences(of: ", ,", with: ",") // Handle consecutive commas
        .replacingOccurrences(of: ",,", with: ",") // Additional cleanup for consecutive commas

    // Split and trim each component
    let components = semiFormattedString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

    // Join the components back into a single string with proper comma separation
    return components.joined(separator: ", ")
}

#Preview {
    OutfitInfoView(showProfileModal: .constant(false), user: MockData.users[1])
}
