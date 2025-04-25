//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

@Observable
class MenuViewModel {
   var game: GameManagerProtocol
   var router: GameRouterProtocol
   var dismissTutorial = false
   init( game: GameManagerProtocol, router: GameRouterProtocol) {
      self.game = game
      self.router = router
   }
}
