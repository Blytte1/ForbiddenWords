//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation

protocol GameRouterProtocol {
    var path: [GameScreen] { get set }
    var currentScreen: GameScreen { get set }
    
    func navigateTo(_ screen: GameScreen)
    func popToRoot()
}
