//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import SwiftUI
import Observation


import SwiftUI // Necessário para @MainActor
import Observation

@MainActor // Garante que as atualizações que afetam a UI ocorram na thread principal
@Observable
class TeamViewModel {
    var gameManager: GameManagerProtocol
    var router: GameRouterProtocol

    private let timerSettingKey = "defaultTimerSetting"
    private let defaultDuration = 60 // Definindo o valor padrão explicitamente

    // Propriedade que lê/escreve duration e salva automaticamente as mudanças
    var duration: Int {
        didSet {
             
             UserDefaults.standard.set(duration, forKey: timerSettingKey)
        }
    }

    init(gameManager: GameManagerProtocol, router: GameRouterProtocol) {
        self.gameManager = gameManager
        self.router = router

        let savedDuration = UserDefaults.standard.integer(forKey: timerSettingKey)
        self.duration = (savedDuration == 0) ? defaultDuration : savedDuration
    }

   // MARK: - Team Management Methods

   func addTeam(name: String) {
      // Certifique-se que seu model 'Team' pode ser inicializado assim
      let newTeam = Team(name: name, cards: [])
      if !newTeam.name.isEmpty {
         gameManager.addTeam(newTeam)
      }
   }

   func removeTeam(team: Team) {
      gameManager.removeTeam(team: team)
   }

   func changeTeamName(team: Team, name: String) {
      gameManager.changeTeamName(team: team, name: name)
   }

    // MARK: - Game State & Actions

    func gameCheck() -> Bool {
        // Verifica se há pelo menos 2 times para o jogo poder começar/ser válido
      return gameManager.game.teams.count > 1
   }
    
   func startGame() {
      Task {
         gameManager.loadDefaultCards()
      }
   }
}

