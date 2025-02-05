//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import SwiftData

struct GameViewFactory {
    let router: GameRouter
   
    @ViewBuilder @MainActor
    func makeView(for screen: GameScreen) -> some View {
        switch screen {
        case .menu:
              let viewModel = MenuViewModel(router: router)

            MenuView(vm: viewModel)
        
        case .team(let game):
            let viewModel = TeamViewModel(game: game,router: router)
            TeamView(vm:viewModel)
        
        case .turn(let game):
            let viewModel = TeamTurnViewModel(game: game,router: router)
            TeamTurn(vm: viewModel)
        
        case .round(let game):
            let viewModel = RoundViewModel(game: game,router: router)
            RoundView(vm: viewModel)
        
        case .winner(let game):
            let viewModel = WinnerViewModel(game: game,router: router)
            WinnerView(vm: viewModel)
        
        case .gallery:
            let viewModel = GalleryViewModel(router: router)
            GalleryOfCards(vm: viewModel)
        }
    }
}



