//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

@MainActor @Observable
class MenuViewModel {
   var game: Game = DummyData.game0
   var router: GameRouter
  
   init( router: GameRouter) {
      self.router = router
   }
}
