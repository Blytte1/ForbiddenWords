//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import Observation


@Observable
class TeamViewModel {
   var gameManager: GameManagerProtocol
   var router: GameRouterProtocol
   
   init(gameManager: GameManagerProtocol, router: GameRouterProtocol) {
      self.gameManager = gameManager
      self.router = router
   }
   
   func addTeam(name: String) {
      let newTeam = Team(name: name, cards: [])
      if !newTeam.name.isEmpty {
         gameManager.addTeam(newTeam)
      }
   }
   
   func removeTeam(team: Team) {
      gameManager.removeTeam(team: team)
   }
   
   func changeTeamName(team: Team, name: String) {
      gameManager.changeTeamName(team: team, name: name)
   }
   
   func gameCheck() -> Bool {
      return gameManager.game.teams.count > 1
   }
   
   func StartGame() {
      Task {
         gameManager.loadDefaultCards()
      }
   }
}

