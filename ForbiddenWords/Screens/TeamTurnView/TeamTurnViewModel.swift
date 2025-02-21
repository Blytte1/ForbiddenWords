//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.


import SwiftUI
import SwiftData


@Observable class TeamTurnViewModel{
   var gameManager: GameManagerProtocol
   var router: GameRouterProtocol
   
   var currentTeam: String {
      gameManager.game.teams[gameManager.currentTeamIndex].name
   }
   
   init(gameManager: GameManagerProtocol, router: GameRouterProtocol) {
      self.gameManager = gameManager
      self.router = router
   }
   
   func insertRound(){
      gameManager.addRound()
   }
}
