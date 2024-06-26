//
//  SwipeActionButtonsView.swift
//  TinderClone
//
//  Created by Tomáš Duchoslav on 02.04.2024.
//

import SwiftUI

struct SwipeActionButtonsView: View {
    
    @ObservedObject var viewModel: CardsViewModel
    
    var body: some View {
        HStack(spacing: 40) {
            Button {
                viewModel.buttonSwipeAction = .reject
            } label: {
                Image(systemName: "xmark")
                    .fontWeight(.heavy)
                    .foregroundStyle(.red)
                    .background {
                        Circle()
                            .fill(.white)
                            .frame(width: 48, height: 48)
                            .shadow(radius: 6)
                    }
            }
            .frame(width: 48, height: 48)
            
            Button {
                viewModel.buttonSwipeAction = .like
            } label: {
                Image(systemName: "pin.fill")
                    .fontWeight(.heavy)
                    .foregroundStyle(Color("colors/blue"))
                    .background {
                        Circle()
                            .fill(.white)
                            .frame(width: 48, height: 48)
                            .shadow(radius: 6)
                    }
            }
            .frame(width: 48, height: 48)
        }
    }
}

#Preview {
    SwipeActionButtonsView(viewModel: CardsViewModel(service: CardService()))
}
