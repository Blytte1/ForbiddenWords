//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI

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
