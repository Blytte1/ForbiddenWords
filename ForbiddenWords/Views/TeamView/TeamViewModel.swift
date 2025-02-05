//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData


@Observable @MainActor
class TeamViewModel: ObservableObject {
   var game: Game
   var router: GameRouter
   
   
   init(game: Game, router: GameRouter) {
      self.game = game
      self.router = router
   }
   
   func addTeam(name: String) {
      let newTeam = Team(name: name, cards: [])
      if newTeam.name != ""{
         game.addTeam(newTeam)
         
      }
   }
   
   func removeTeam(team: Team) {
      if let index = game.teams.firstIndex(where: { $0.id == team.id }) {
         game.teams.remove(at: index)
         
      }
   }
   
   func changeTeamName(team: Team, name: String) {
      if let index = game.teams.firstIndex(where: { $0.id  == team.id }) {
         game.teams[index].name = name
      }
   }
   
   func gameCheck() -> Bool{
      game.teams.count>1
   }
   
   func StartGame(){
      game.shuffleTeamsOrder()
      game.getDefaultCards()
   }
}
