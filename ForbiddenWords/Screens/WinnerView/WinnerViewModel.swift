//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.


import SwiftUI
import SwiftData

@Observable
class WinnerViewModel{
   var gameManager: GameManagerProtocol
   var router: GameRouterProtocol
   
   init(gameManager: GameManagerProtocol, router: GameRouterProtocol) {
      self.gameManager = gameManager
      self.router = router
   }
   /// Reseta o jogo e cria um novo
   func resetGame() {
          gameManager.resetGame()
         router.popToRoot()
   }
   func getWinner() -> String {
       return   gameManager.teamWithMostCards()
   }
}
