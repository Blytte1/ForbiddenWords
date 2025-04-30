//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Foundation

protocol GameManagerProtocol {
    var game: Game { get set }
    var maxRoundNumbers: Int { get set }
    var soundOn: Bool { get set }
    var maxSkipCount: Int { get set }
    var skipCount: Int { get set }
    var currentRoundId: Int { get set }
    var currentTeamIndex: Int { get set }
    
    init(game: Game, cardManager: CardManager)
    
    func createGame()
    func resetGame()
    func getGameState() -> GameState
    func teamWithMostCards() -> String
    
    func addTeam(_ team: Team)
    func addRound()
    func changeTeam()
    func changeTeamName(team: Team, name: String)
    func removeTeam(team: Team)
    
    func dealCard(answer: Bool, team: Team) async throws
    func giveCardToTeam(card: Card, team: Team) throws
    func loadDefaultCards()
    func removeCard(_ card: Card) throws
    func skipCard()
}
