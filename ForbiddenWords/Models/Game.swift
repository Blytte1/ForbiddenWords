//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.


import Foundation

class Game{

   var teams: [Team] = [DummyData.team,DummyData.team2]
   var cards: [Card] = []
   var rounds: [Round] = []

   init(teams: [Team], cards: [Card], rounds: [Round]) {
      self.teams = teams
      self.cards = cards
      self.rounds = rounds
   }
}
