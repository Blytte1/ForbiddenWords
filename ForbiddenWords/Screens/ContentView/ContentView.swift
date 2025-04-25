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
      self.factory = GameViewFactory(router: router, gameManager: gameManager, modelContainer: modelContainer)
       self.modelContainter = DataManager.shared.container
   }
   
   var body: some View {
      NavigationStack(path: $router.path) {
         factory.makeView(for: router.currentScreen)
            .navigationDestination(for: GameScreen.self) { screen in
               factory.makeView(for: screen)
            }
      }
      .statusBar(hidden: true)
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
       let container = DataManager.makePreviewContainer()
      let router = GameRouter()
       let gameManager = GameManager(game:DummyData.game0, cardManager: CardManager(context: DataManager.shared.context))
       ContentView(router: router, gameManager: gameManager, modelContainer: container)
           .modelContext(container.mainContext)
   }
}
