//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

enum GameManagerError: Error {
   case gameNotInitialized
}

@MainActor
class GameManager {
   var game: Game?
   var maxRoundNumbers: Int
   var currentTeamIndex: Int = 0
   var currentRoundIndex: Int = 1
   
   init(maxRoundNumbers: Int) {
      self.maxRoundNumbers = maxRoundNumbers
   }
   
   func createGame(teams: [Team]) {
      self.game = Game(maxRoundNumbers: maxRoundNumbers, teams: teams, teamIndex: 0, roundIndex: 1, cards: [], rounds: [])
   }
   
   func getWonCard(card: Card, team: Team)async throws {
      guard let game = self.game else {
         throw GameManagerError.gameNotInitialized
      }
      game.appendCardToTeam(card: card, team: team)
      try await removeCard(card)
   }
   
   func getLostCard(card: Card, team: Team) async throws {
      guard let game = self.game else {
         throw GameManagerError.gameNotInitialized
      }
      game.appendCardToTeam(card: card, team: team)
     try await removeCard(card)
   }
   
   func changeTeam() async throws {
      guard let game = self.game else {
         throw GameManagerError.gameNotInitialized
      }
      let index = (currentTeamIndex + 1) % game.teams.count
      currentTeamIndex = index
   }
   
   func addTeam(_ team: Team) async throws {
      guard let game = self.game else {
         throw GameManagerError.gameNotInitialized
      }
      game.teams.append(team)
   }
   
   func shuffleTeamsOrder() async throws {
      guard let game = self.game else {
         throw GameManagerError.gameNotInitialized
      }
      game.teams.shuffle()
   }
   
   func removeCard(_ card: Card) async throws {
      guard let game = self.game else {
         throw GameManagerError.gameNotInitialized
      }
      if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
         game.cards.remove(at: index)
      }
   }
   
   func getDefaultCards() async throws {
      guard let game = self.game else {
         throw GameManagerError.gameNotInitialized
      }
      game.cards.insert(contentsOf: DummyData.cards, at: game.cards.count)
      game.cards.shuffle()
   }
   
   func addRound() async throws {
      guard let game = self.game else {
         throw GameManagerError.gameNotInitialized
      }
      if  self.currentRoundIndex != maxRoundNumbers{
         currentRoundIndex += 1
         game.rounds.append(Round(RoundNumber: currentRoundIndex))
      } else {
         currentTeamIndex = 0
      }
   }
   
   func appendCardToTeam(card: Card, team: Team) async  throws {
      guard let game = self.game else {
         throw GameManagerError.gameNotInitialized
      }
      game.teams.first(where: { $0.id == team.id })?.cards.append(card)
   }
   
   func teamWithMostCards() async throws -> String {
      guard let game = self.game else {
         throw GameManagerError.gameNotInitialized
      }
      guard !game.teams.isEmpty else { return "Não há times no jogo." }
      
      let maxCards = game.teams.map(\.cards.count).max() ?? 0
      let teamsWithMaxCards = game.teams.filter { $0.cards.count == maxCards }
      
      if teamsWithMaxCards.count > 1 {
         return "Jogo Empatado!"
      } else if let winningTeam = teamsWithMaxCards.first {
         return "\(winningTeam.name) venceu!"
      } else {
         return "Não há times com cartas."
      }
   }
}
