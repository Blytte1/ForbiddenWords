//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation
import SwiftData

@Model class Card{
    
    var id: Int
    var keyWord: String
    var forbiddenWords: [String]
    var answerIsRight: Bool?

    init(id: Int, keyWord: String, forbiddenWords: [String]) {
        self.id = id
        self.keyWord = keyWord
        self.forbiddenWords = forbiddenWords
    }
}

enum CardCategory: String, CaseIterable, Identifiable {
    
    var id: String { self.rawValue }
    
    case objects = "Objetos"
    case places = "Lugares"
    case colors = "Cores"
    case animals = "Animais"
    case food = "Comida"
    case professions = "Profissões"
    case gamesAndSports = "Jogos e Esportes"
    case events = "Eventos"
    case emotions = "Emoções"
    case abstractConcepts = "Conceitos Abstratos"
    case people = "Pessoas"
}
