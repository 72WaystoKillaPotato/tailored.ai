//
//  UserInfoView.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import SwiftUI

struct OutfitInfoView: View {
    
    @Binding var showProfileModal: Bool
    
    let user: Outfit
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(user.description)
                    .font(.title)
                    .fontWeight(.heavy)
                
                Spacer()
                
                Button {
                    showProfileModal.toggle()
                } label: {
                    Image(systemName: "arrow.up.circle")
                        .imageScale(.large)
                        .fontWeight(.bold)
                }
            }
            Text("Some test bio")
                .font(.subheadline)
                .lineLimit(2)
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
        )
      
    }
}

#Preview {
    OutfitInfoView(showProfileModal: .constant(false), user: MockData.users[1])
}
