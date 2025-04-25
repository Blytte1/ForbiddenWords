//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation

protocol GameManagerProtocol {
    // Propriedades
    var game: Game { get set }  // Jogo atual
    var maxRoundNumbers: Int { get set }  // Número máximo de rodadas
    var soundOn: Bool { get set }  // Estado do som
    var currentRoundId: Int { get set }  // ID da rodada atual
    var currentTeamIndex: Int { get set }  // Índice do time atual

    // Métodos de gerenciamento do jogo
    func createGame()
    func resetGame()
    func getGameState() -> GameState
    func teamWithMostCards() -> String

    // Métodos de manipulação de rodadas e times
    func addTeam(_ team: Team)
    func addRound()
    func changeTeam()
    func changeTeamName(team: Team, name: String)
    func removeTeam(team: Team)

    // Métodos de manipulação de cartas
    func dealCard(answer: Bool, team: Team) async throws
    func loadDefaultCards()
    func skipCard() // Método para pular uma carta
    func giveCardToTeam(card: Card, team: Team) throws // Distribui uma carta para um time
    func removeCard(_ card: Card) throws // Remove uma carta
}
