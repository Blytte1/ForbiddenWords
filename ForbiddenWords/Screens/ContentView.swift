//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct ContentView: View {
   @State private var router: GameRouterProtocol
   private var factory: GameViewFactory
   private var modelContainter: ModelContainer
   init(router: GameRouterProtocol, gameManager: GameManagerProtocol,modelContainer: ModelContainer) {
      self.router = router
      self.factory = GameViewFactory(router: router, gameManager: gameManager, modelContainer: try! ModelContainer(for: Card.self))
      self.modelContainter = try! ModelContainer(for:Card.self)
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
      let gameManager = GameManager(game:DummyData.game0, cardManager: CardManager(context: ModelContext(try! ModelContainer(for: Card.self))))
      ContentView(router: router, gameManager: gameManager, modelContainer: try! ModelContainer(for: Card.self))
   }
}
