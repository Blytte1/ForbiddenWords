//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

@Observable @MainActor class RoundViewModel{
   var game: Game
   var router: GameRouter
   var teamCount: Int  {game.teams.count}
   var currentTeamIndex: Int {game.currentTeamIndex}
   var currentTeam: Team { game.teams[game.currentTeamIndex]}
   var showTeamList = false
   var opacity: Double = 0
   var skipCount: Int = 0
   var maxSkipCount: Int = 3
   var buttonIsDisabled: Bool = false
   init(game: Game, router: GameRouter) {
      self.game = game
      self.router = router
   }
   
   func dealCard(answer: Bool) {
      guard let firstCard = game.cards.first,!game.teams.isEmpty else {
         print("Error: There are no Cards or Teams Available.")
         return
      }
      
      if answer {
         game.getWonCard(game: game, card: firstCard, team: currentTeam)
         print("A carta \(firstCard.keyWord) foi recebida pela equipe \(currentTeam.name)")
      } else {
         // Calcula o índice da próxima equipe (sem modificar teamIndex)
         let nextTeamIndex = currentTeamIndex == teamCount-1 ? 0 : (currentTeamIndex + 1)
         let nextTeam = game.teams[nextTeamIndex]
         
         game.getLostCard(game: game, card: firstCard, team: nextTeam)
         print("A carta \(firstCard.keyWord) foi perdida e atribuída à equipe \(nextTeam.name)")
      }
      game.removeCard(firstCard)
   }
   
  private func getGameState() -> GameState {
     guard  !game.teams.isEmpty else {
         print("Rounds is empty")
         return .error
      }
     let LastRound = game.currentRoundIndex == game.maxRoundNumbers
     let lastTeamHasPlayed = game.currentTeamIndex == game.teams.count - 1
     
     if LastRound {
        if lastTeamHasPlayed {
            print("Game Over")
            return .gameOver
         } else {
            return .nextTeam
         }
        
      } else {
         if lastTeamHasPlayed {
            print("Next Round")
            return .nextRound
         } else {
            print("Same round Next Team")
            return .nextTeam
         }
      }
   }
   func winCards(){
      if game.cards.count > 0 {
         game.cards[0].answerIsRight = true
      }
   }
   func concedeCards(){
      if game.cards.count > 0 {
         game.cards[0].answerIsRight = false
      }
   }
   func skipCard() {
      guard !game.cards.isEmpty else { return }
      if skipCount < 3{
         let first = game.cards.removeFirst()
         game.cards.append(first)
         print(game.cards[0].keyWord)
         print(game.cards.last!.keyWord)
         skipCount += 1
      } else {
         buttonIsDisabled = true
      }
   }
   
   func isGameOver() {
      let state = getGameState()
      switch state {
         case .gameOver:
            router.navigateTo(.winner(game))
            buttonIsDisabled = false
            print("Game Over")
         case .nextTeam:
            buttonIsDisabled = false
            game.changeTeam()
            router.navigateTo(.turn(game))
            print("Next Team Turn")
         case .nextRound:
            buttonIsDisabled = false
            game.addRound()
            router.navigateTo(.turn(game))
            print("A New Round has been Started")
         case .error:
            print("Theres been an error.")
      }
   }
   
   enum GameState {
      case gameOver
      case nextTeam
      case nextRound
      case error
   }
}
