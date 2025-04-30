//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

@main
struct ForbiddenWordsApp: App {
    let container = DataManager.shared
   
   // Criando instâncias para injeção de dependência
   @State private var router = GameRouter()
   @State private var gameManager: GameManager
   init(){
       UserDefaults.standard.register(defaults: [
           "maxRoundNumbers": 3, // <- Padrão para rounds
           "defaultTimerSetting": 60, // <- Padrão para duração (exemplo)
           "soundOn": true, // <- Padrão para som (exemplo)
           "maxSkipCount":3
       ])
       print("UserDefaults padrões registrados.")
      gameManager = GameManager(game: Game(
         teams: [Team(name: "Equipe 1", cards: []),Team(name: "Equipe 2", cards: [])],
         cards: [],
         rounds: [Round(RoundNumber: 1)]
      ), cardManager: CardManager(context: container.context))
   }
   
   var body: some Scene {
      WindowGroup {
          ContentView(router: router, gameManager: gameManager, modelContainer: container.container)
              .modelContext(container.container.mainContext)
      }
   }
}

