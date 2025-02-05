//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.


import SwiftUI
import SwiftData

@Observable @MainActor
class WinnerViewModel{
   var game: Game
   var router: GameRouter
   
   init(game: Game, router: GameRouter) {
      self.game = game
      self.router = router
   }
}