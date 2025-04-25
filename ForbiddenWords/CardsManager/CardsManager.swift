//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftData
import SwiftUI
import Observation

@MainActor
@Observable
class CardManager {
    var context = DataManager.shared.context

    var dbCards: [Card] = []
    
    //Default categories
    var defaultCategories: [String] = DummyData.defaultCardsCategories
    
    var customCategories: [String] {
        didSet {
            saveCustomCategories()
        }
    }
    
    var categories: [String] {
        return defaultCategories + customCategories
    }
    
    init(context: ModelContext) {
        self.context = context
        self.customCategories = UserDefaults.standard.stringArray(forKey: "customCategories") ?? []
        fetchCustomCards()  // Busca os cartões do SwiftData.
        
        if dbCards.isEmpty {
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
    func createCustomCard(keyWord: String, forbiddenWords: [String], categories: [String] = ["TODAS","CARTAS CUSTOMIZADAS"]) throws {
        guard !keyWord.isEmpty, !forbiddenWords.isEmpty else {
            throw CardManagerError.invalidCardData
        }
        
        let nextID = nextAvailableID()
        let newCard = Card(id: nextID, keyWord: keyWord, forbiddenWords: forbiddenWords, categories: categories)
        context.insert(newCard)
        
        try context.save()
        fetchCustomCards()
    }
    
    // Função para gerar o próximo ID disponível
    private func nextAvailableID() -> Int {
        let maxID = dbCards.max(by: { $0.id < $1.id })?.id ?? 0
        return maxID + 1
    }
    
    // Função para buscar os cartões customizados
    private func fetchCustomCards() {
        let fetchDescriptor = FetchDescriptor<Card>(sortBy: [SortDescriptor(\Card.id)])
        do {
            dbCards = try context.fetch(fetchDescriptor)
        } catch {
            print("Erro ao buscar cartões: \(error)")
            dbCards = []
        }
    }
    
    // Remove um cartão pelo ID
    func removeCard(id: Int) throws {
        // Verifica se o cartão existe
        guard let index = dbCards.firstIndex(where: { $0.id == id }) else {
            throw CardManagerError.cardNotFound
        }
        
        let cardToRemove = dbCards[index]
        
        context.delete(cardToRemove)
        
        try context.save()
        
        fetchCustomCards()
    }
    // Função para persistir categorias customizadas
    func saveCustomCategories() {
        UserDefaults.standard.set(customCategories, forKey: "customCategories")
    }
    // Função para inserir as cartas padrão do DummyData no SwiftData.
    private func insertDefaultCards() {
        for card in DummyData.defaultCards{
            context.insert(card) // Insere no SwiftData.
        }
        do {
            try context.save()  // Salva as mudanças no contexto.
            fetchCustomCards()    // Recarrega os cartões, agora incluindo os default.
        } catch {
            print("Erro ao inserir defaultCards: \(error)")
        }
    }
}
