//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.
import SwiftUI
import SwiftData

@Observable
class GameRouter: GameRouterProtocol {
   var path:[GameScreen] = []
   var currentScreen: GameScreen = .menu
   
   init() { }
   
   func navigateTo(_ screen: GameScreen) {
      // Verifica se a tela atual é a mesma que a nova tela antes de navegar
      if currentScreen != screen {
         currentScreen = screen
         path.append(currentScreen) // Adiciona a nova tela ao caminho
      }
   }
   
   func popToRoot() {
      path.removeLast(path.count)
      currentScreen = .menu
   }
}

