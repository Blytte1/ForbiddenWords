//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct GameViewFactory {
   let router: GameRouterProtocol
   let gameManager: GameManagerProtocol
   let modelContainer: ModelContainer
    @ViewBuilder @MainActor
    func makeView(for screen: GameScreen) -> some View {
        switch screen {
        case .menu:
              let viewModel = MenuViewModel(game: gameManager, router: router)

            MenuView(vm: viewModel)
        
           case .team:
              let viewModel = TeamViewModel(gameManager: gameManager,router: router)
            TeamView(vm:viewModel)
        
        case .turn:
              let viewModel = TeamTurnViewModel(gameManager: gameManager,router: router)
            TeamTurnView(vm: viewModel)
        
        case .round:
              let viewModel = RoundViewModel(gameManager: gameManager,router: router)
            RoundView(vm: viewModel)
        
        case .winner:
              let viewModel = WinnerViewModel(gameManager: gameManager,router: router)
            WinnerView(vm: viewModel)
        
        case .gallery:
              let viewModel = GalleryViewModel(router: router, context: ModelContext(modelContainer))
            GalleryView(vm: viewModel)
        }
    }
}



