//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI

struct ContentView: View {
   @State private var router: GameRouterProtocol
   private var factory: GameViewFactory
   
   init(router: GameRouterProtocol, gameManager: GameManagerProtocol) {
      self.router = router
      self.factory = GameViewFactory(router: router, gameManager: gameManager)
   }
   
   var body: some View {
      NavigationStack(path: $router.path) {
         factory.makeView(for: router.currentScreen)
            .navigationDestination(for: GameScreen.self) { screen in
               factory.makeView(for: screen)
            }
      }
      
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      let router = GameRouter()
      let gameManager = GameManager(game:DummyData.game0)
      ContentView(router: router, gameManager: gameManager)
   }
}
