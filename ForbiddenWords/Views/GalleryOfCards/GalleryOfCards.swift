//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import Observation

struct GalleryOfCards: View {
 
    @StateObject var vm: GalleryViewModel
    
    var body: some View {
        VStack {
            Text("Escolha uma categoria:")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.orange)
            VerticalPicker(selection:$vm.selectedCategory, options: vm.categories)

            TabView(selection: $vm.cardIndex) {
                ForEach(vm.filteredCards.indices, id: \.self) { index in
                    VStack {
                       CardView(card: vm.filteredCards[index])
                            .scaleEffect(0.70)
                        
                        Button("Próxima Carta") {
                            vm.nextCard() // Chama a função nextCard()
                        }
                        .buttonStyle(gameButtonStyle())
                        .padding(.vertical)
                    }
                    .ignoresSafeArea(edges: [.bottom])
                    .tag(index) // Define a tag para o TabView
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(.page)
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = .clear
                UIPageControl.appearance().pageIndicatorTintColor = .clear
            }
        }
        .background {
            ZStack {
                Color.black
                    .ignoresSafeArea(edges: [.top])
            }
        }
        .ignoresSafeArea(edges: [.bottom])
    }
}

#Preview {
    GalleryOfCards(vm: GalleryViewModel(router:GameRouter()))
}
