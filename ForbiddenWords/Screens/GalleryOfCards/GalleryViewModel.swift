//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.


import SwiftUI
import Observation

@Observable class GalleryViewModel: ObservableObject {
   var router: GameRouterProtocol
    var cardIndex = 0
    var selectedCategory = "Objetos"
    var categories = CardCategory.allCases.map{$0.rawValue}
    
    var filteredCards: [Card] {
        switch selectedCategory {
        case "Objetos": return DummyData.objectsCards
        case "Lugares": return DummyData.placesCards
        case "Cores": return DummyData.colorsCards
        case "Animais": return DummyData.animalsCards
        case "Comida": return DummyData.foodCards
        case "Profissões": return DummyData.professionsCards
        case "Jogos e Esportes": return DummyData.gameAdnSportsCards
        case "Eventos": return DummyData.eventsCards
        case "Emoções": return DummyData.emotionsCards
        case "Conceitos Abstratos": return DummyData.abstractConceptCards
        case "Pessoas": return DummyData.peopleCards
        default: return [] // Retorna um array vazio caso a categoria não seja encontrada
        }
    }
    
   init(router: GameRouterProtocol){
        self.router = router
    }
    
    func nextCard() {
        if cardIndex < filteredCards.count - 1 {
            withAnimation(.bouncy) {
                cardIndex += 1
            }
        }
    }
}
