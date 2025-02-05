//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftData
import Foundation


@Model class Game{

    var teams: [Team] = [DummyData.team,DummyData.team2]
    var cards: [Card] = []
    var rounds: [Round] = []
    var maxRoundNumbers: Int
    var currentTeamIndex: Int = 0
    var currentRoundIndex: Int = 1

   init(id: UUID = UUID(), maxRoundNumbers: Int, teams: [Team], teamIndex: Int, roundIndex: Int, cards: [Card], rounds: [Round]) {
    
      self.maxRoundNumbers = maxRoundNumbers
      self.teams = teams
      self.currentTeamIndex = teamIndex
      self.currentRoundIndex = roundIndex
      self.cards = cards
      self.rounds = rounds
   }
   
   func getWonCard(game:Game, card: Card, team: Team)  {
      game.appendCardToTeam(card: card, team: team)
      removeCard(card)
   }
   func getLostCard(game:Game, card: Card,team: Team)  {
      game.appendCardToTeam(card: card, team: team)
      removeCard(card)
   }
   
   func changeTeam() {
      let index = (currentTeamIndex + 1) % teams.count
      currentTeamIndex = index
   }
   
   func addTeam(_ team: Team) {
      teams.append(team)
   }
   
   func shuffleTeamsOrder() {
      teams.shuffle()
   }
   
   func removeCard(_ card: Card) {
      if let index = cards.firstIndex(where: { $0.id == card.id }) {
         cards.remove(at: index)
      }
   }
   
   func getDefaultCards() {
      cards.insert(contentsOf: DummyData.cards, at: cards.count)
      cards.shuffle()
   }
   
   func addRound(){
      if  self.currentRoundIndex != maxRoundNumbers{
         currentRoundIndex += 1
         rounds.append(Round(RoundNumber: currentRoundIndex))
      }else{
         currentTeamIndex = 0
      }
   }
   func appendCardToTeam(card: Card, team: Team) {
      teams.first(where: { $0.id == team.id })?.cards.append(card)
   }
   
   func teamWithMostCards() -> String {
      guard !teams.isEmpty else { return "Não há times no jogo." }
      
      let maxCards = teams.map(\.cards.count).max() ?? 0 // Obtém o número máximo de cartas
      let teamsWithMaxCards = teams.filter { $0.cards.count == maxCards }
      
      if teamsWithMaxCards.count > 1 {
         return "Jogo Empatado!"
      } else if let winningTeam = teamsWithMaxCards.first {
         return "\(winningTeam.name) venceu!"
      } else {
         return "Não há times com cartas." // Caso improvável, mas para garantir
      }
   }
}
