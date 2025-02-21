//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

@Observable @MainActor
class RoundViewModel {
   var gameManager: GameManagerProtocol
   var router: GameRouterProtocol
   
   var teamCount: Int {
      gameManager.game.teams.count
   }
   
   var currentTeamIndex: Int {
      gameManager.currentTeamIndex
   }
   
   var currentTeam: Team {
      gameManager.game.teams[gameManager.currentTeamIndex]
   }
   
   var showTeamList = false
   var opacity: Double = 0
   var skipCount: Int = 0
   var maxSkipCount: Int = 3
   var buttonIsDisabled: Bool = false
   
   init(gameManager: GameManagerProtocol, router: GameRouterProtocol) {
      self.gameManager = gameManager
      self.router = router
   }
   
   /// Distribui uma carta para um time com base na resposta
   func dealCard(answer: Bool) async {
      guard let firstCard = gameManager.game.cards.first, !gameManager.game.teams.isEmpty else {
         print("Error: There are no Cards or Teams Available.")
         return
      }
      
      do {
         try await gameManager.dealCard(answer: answer, team: currentTeam)
         print("A carta \(firstCard.keyWord) foi atribuída à equipe \(currentTeam.name)")
      } catch {
         print("Erro ao distribuir carta: \(error.localizedDescription)")
      }
   }
   
   /// Verifica se o jogo terminou e navega para a próxima tela
   func isGameOver() {
      let state = gameManager.getGameState()
      
      switch state {
         case .gameOver:
            router.navigateTo(.winner)
            buttonIsDisabled = false
            print("Game Over")
         case .nextTeam:
            buttonIsDisabled = false
            gameManager.changeTeam()
            router.navigateTo(.turn)
            print("Next Team Turn")
         case .nextRound:
            buttonIsDisabled = false
            gameManager.addRound()
            router.navigateTo(.turn)
            print("A New Round has been Started")
         case .error:
            print("There's been an error.")
      }
   }
   
   /// Marca a carta atual como correta
   func winCards() {
      gameManager.markCardAsAnswered(correct: true)
   }
   
   /// Marca a carta atual como errada
   func concedeCards() {
      gameManager.markCardAsAnswered(correct: false)
   }
   
   /// Pula a carta atual
   func skipCard() {
      if skipCount < maxSkipCount {
         gameManager.skipCard()
         skipCount += 1
      } else {
         buttonIsDisabled = true
      }
   }
}

   

