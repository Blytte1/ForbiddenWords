//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftData
import SwiftUI

@Observable
class CardManager {
   var context: ModelContext?
   
   //Cards directly do SwiftData
   var customCards: [Card] = []
   
   //Default categories
   var defaultCategories: [String] = DummyData.defaultCardsCategories
   
   var customCategories: [String] {
      didSet {
         saveCustomCategories()
      }
   }
   
   var cards: [Card] {
      return  customCards
   }

   var categories: [String] {
      return defaultCategories + customCategories
   }
   
   init(context: ModelContext?) {
      self.context = context
      self.customCategories = UserDefaults.standard.stringArray(forKey: "customCategories") ?? []
      fetchCustomCards()  // Busca os cartões do SwiftData.
      
      if customCards.isEmpty {
         insertDefaultCards()
      }
   }
   
   // MARK: - Category Management
   
   // Adiciona uma nova categoria, se ela já não existir.
   func insertCategory(category: String) throws {
      guard !categories.contains(category) else {
         throw CardManagerError.categoryAlreadyExists
      }
      customCategories.append(category)
      customCategories.sort()
   }
   
   
   // Remove uma categoria existente.
   func removeCategory(category: String) throws {
      guard categories.contains(category) else {
         throw CardManagerError.categoryNotFound
      }
      customCategories.removeAll { $0 == category }
   }
   
   // MARK: - Card Management
   func createCard(keyWord: String, forbiddenWords: [String], categories: [String] = ["TODAS","CARTAS CUSTOMIZADAS"]) throws {
      guard !keyWord.isEmpty, !forbiddenWords.isEmpty else {
         throw CardManagerError.invalidCardData
      }
      
      let nextID = nextAvailableID()
      let newCard = Card(id: nextID, keyWord: keyWord, forbiddenWords: forbiddenWords, categories: categories)
      context?.insert(newCard)
      
      try context?.save()
      fetchCustomCards()
   }
   
   // Função para gerar o próximo ID disponível
   private func nextAvailableID() -> Int {
      let maxID = customCards.max(by: { $0.id < $1.id })?.id ?? 0
      return maxID + 1
   }
   
   // Função para buscar os cartões customizados
   private func fetchCustomCards() {
      let fetchDescriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\Card.id)])
      do {
         customCards = try context?.fetch(fetchDescriptor) ?? []
      } catch {
         print("Erro ao buscar cartões: \(error)")
         customCards = []
      }
   }
   
   // Remove um cartão pelo ID
   func removeCard(id: Int) throws {
      // Verifica se o cartão existe
      guard let index = customCards.firstIndex(where: { $0.id == id }) else {
         throw CardManagerError.cardNotFound
      }
      
      let cardToRemove = customCards[index]
      
      context?.delete(cardToRemove)
      
      try context?.save()
      
      fetchCustomCards()
   }
   
   // Função para persistir categorias customizadas
   func saveCustomCategories() {
      UserDefaults.standard.set(customCategories, forKey: "customCategories")
   }
   
   // Função para inserir as cartas padrão do DummyData no SwiftData.
   private func insertDefaultCards() {
      for (category, ids) in DummyData.defaultCardsDictionary {
         for id in ids {
            //Encontra a carta correta no array 'defaultCards'.
            if let cardData = DummyData.uncategorizedCards.first(where: { $0.id == id }) {
               let newCard = Card(id: cardData.id, keyWord: cardData.keyWord, forbiddenWords: cardData.forbiddenWords, categories: [category])
               context?.insert(newCard) // Insere no SwiftData.
            }
         }
      }
      do {
         try context?.save()  // Salva as mudanças no contexto.
         fetchCustomCards()    // Recarrega os cartões, agora incluindo os default.
      } catch {
         print("Erro ao inserir defaultCards: \(error)")
      }
   }
}

