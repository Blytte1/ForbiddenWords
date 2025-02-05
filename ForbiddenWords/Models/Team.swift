//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation
import SwiftData

@Model
class Team {
   var teamId = UUID()
   var name: String
   var cards: [Card] = []
   
   init(name: String, cards: [Card]) {
      self.name = name
      self.cards = cards
   }
}
   
  

