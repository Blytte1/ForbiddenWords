//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.


import SwiftUI
import SwiftData

@MainActor
@Observable class GalleryViewModel {
   var router: GameRouterProtocol
   private var cardManager: CardManager
   var cardIndex = 0
   var newKeyword = ""
   var newForbiddenWord1 = ""
   var newForbiddenWord2 = ""
   var newForbiddenWord3 = ""
   var newForbiddenWord4 = ""
   var newForbiddenWord5 = ""
   
   // Propriedade computada para criar um novo cartão. Útil para visualizações de formulário.
   var newCard: Card {
      return Card(id: 1000, keyWord: newKeyword, forbiddenWords: [newForbiddenWord1, newForbiddenWord2, newForbiddenWord3, newForbiddenWord4, newForbiddenWord5], categories: ["TODAS", "CARTAS CUSTOMIZADAS"])
   }
   
   var selectedCategory = "TODAS" {
      didSet {
         // Resetar o índice do cartão quando a categoria for alterada.
         cardIndex = 0
      }
   }
   
   // Obtém as categorias do gerenciador de cartões.
   var categories: [String] {
      cardManager.categories
   }
   
   // Filtra e ordena os cartões com base na categoria selecionada.
   var filteredCards: [Card] {
      let filtered = cardManager.dbCards.filter {
         selectedCategory == "TODAS" || $0.categories.contains(selectedCategory)
      }
      return filtered.sorted(by: { $0.keyWord.localizedStandardCompare($1.keyWord) == .orderedAscending })
   }
   
   // Mensagem de erro para feedback do usuário.
   var errorMessage: String?
   
   // Modificando o inicializador para receber o ModelContext
   init(router: GameRouterProtocol, context: ModelContext) {
      self.router = router
      self.cardManager = CardManager(context: context)
   }
   
   // Avança para o próximo cartão com animação.
   func nextCard() {
      if cardIndex < filteredCards.count - 1 {
         withAnimation(.bouncy) {
            cardIndex += 1
         }
      }
   }
   
   // Cria um novo cartão no gerenciador de cartões.
   func createCard() {
      // Validação da palavra-chave.
      guard !newKeyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
         errorMessage = "A palavra-chave não pode estar em branco."
         return
      }
      
      // Limpeza e validação das palavras proibidas.
      let forbiddenWords = [newForbiddenWord1, newForbiddenWord2, newForbiddenWord3, newForbiddenWord4, newForbiddenWord5]
         .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
         .filter { !$0.isEmpty }
      
      // Verifica a unicidade das palavras proibidas.
      let uniqueForbiddenWords = Set(forbiddenWords)
      if uniqueForbiddenWords.count != forbiddenWords.count {
         errorMessage = "As Palavras proibidas não podem se repetir."
         return
      }
      
      // Verifica se existem 5 palavras proibidas.
      if forbiddenWords.count < 5 {
         errorMessage = "São necessárias todas as 5 palavras proibidas."
         return
      }
      
      errorMessage = nil
      
      // Tenta criar o cartão e limpa os campos em caso de sucesso.
      do {
         try cardManager.createCustomCard(keyWord: newKeyword, forbiddenWords: forbiddenWords)
         // Limpa os campos do formulário.
         self.newKeyword = ""
         self.newForbiddenWord1 = ""
         self.newForbiddenWord2 = ""
         self.newForbiddenWord3 = ""
         self.newForbiddenWord4 = ""
         self.newForbiddenWord5 = ""
      } catch {
         errorMessage = "Error creating card: \(error.localizedDescription)"
         print("Error creating card: \(error)")
      }
   }
}

