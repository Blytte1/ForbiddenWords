//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

@main
struct ForbiddenWordsApp: App {
   let container = try! ModelContainer(for: Card.self)
   
   // Criando instâncias para injeção de dependência
   @State private var router = GameRouter()
   @State private var gameManager: GameManager
   init(){
      gameManager = GameManager(game: Game(
         teams: [Team(name: "Equipe 1", cards: []),Team(name: "Equipe 2", cards: [])],
         cards: [],
         rounds: [Round(RoundNumber: 1)]
      ), cardManager: CardManager(context: ModelContext(try! ModelContainer(for: Card.self))))
   }
   
   var body: some Scene {
      WindowGroup {
         ContentView(router: router, gameManager: gameManager, modelContainer: container)
            .modelContext(container.mainContext)
      }
   }
}

