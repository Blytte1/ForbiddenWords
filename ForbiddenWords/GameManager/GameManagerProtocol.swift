//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation

protocol GameManagerProtocol {
   
   // MARK: - Propriedades
   
   var game: Game { get set }
   var maxRoundNumbers: Int { get }
   var currentRoundId: Int { get set }
   var currentTeamIndex: Int { get set }
   
   // MARK: - Métodos de Gerenciamento do Jogo
   
   func createGame() async throws
   func getGameState() -> GameState
   func resetGame() async throws
   func teamWithMostCards() -> String
   
   // MARK: - Métodos de Manipulação de Rodadas e Times
   
   func addRound()
   func addTeam(_ team: Team)
   func changeTeam()
   func changeTeamName(team: Team, name: String)
   func removeTeam(team: Team)
   
   // MARK: - Métodos de Manipulação de Cartas
   
   func dealCard(answer: Bool, team: Team) async throws
   func giveCardToTeam(card: Card, team: Team) async throws
   func loadDefaultCards()
   func removeCard(_ card: Card) throws
   func skipCard()
}
