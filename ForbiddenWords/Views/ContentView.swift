//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI

struct ContentView: View {
    @State private var router: GameRouter
    private var factory: GameViewFactory

    init() {
        let router = GameRouter()
        self.router = router
        self.factory = GameViewFactory(router: router)
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            factory.makeView(for: router.currentScreen)
                .navigationDestination(for: GameScreen.self) { screen in
                    factory.makeView(for: screen)
                }
        }
        .environment(router)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
