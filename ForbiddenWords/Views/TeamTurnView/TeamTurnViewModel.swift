//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.


import SwiftUI
import SwiftData

@MainActor
@Observable class TeamTurnViewModel{
   var game: Game
   var router: GameRouter
   
   var currentTeam: String {
      guard !game.teams.isEmpty else{ return "Não há equipes cadastradas"}
      return game.teams[game.currentTeamIndex].name
   }
   
   init(game: Game, router: GameRouter) {
      self.game = game
      self.router = router
   }
   
   func insertRound(){
      game.addRound()
   }
}
