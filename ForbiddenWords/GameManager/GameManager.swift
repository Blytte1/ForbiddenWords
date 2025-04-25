//
// Created by Roberto Mascarenhas.
// Copyright (c) Roberto Mascarenhas. All rights reserved.

import Observation
import SwiftUI

@MainActor
@Observable
class GameManager: @preconcurrency GameManagerProtocol {
    private let cardManager: CardManager
    var game: Game
    private let maxRoundsKey = "maxRoundNumbers"
    private let soundKey = "soundOn"
    private let defaultMaxRounds: Int = 3
    var currentRoundId: Int = 1
    var currentTeamIndex: Int = 0
    var maxRoundNumbers: Int {
        get {
            UserDefaults.standard.integer(forKey: maxRoundsKey) == 0 ? defaultMaxRounds : UserDefaults.standard.integer(forKey: maxRoundsKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: maxRoundsKey)
        }
    }
    var soundOn: Bool {
           get {
               UserDefaults.standard.object(forKey: soundKey) as? Bool ?? true
           }
           set {
               UserDefaults.standard.set(newValue, forKey: soundKey)
           }
       }
    
    init(game: Game, cardManager: CardManager) {
        self.game = game
        self.cardManager = cardManager
        self.soundOn = UserDefaults.standard.object(forKey: "soundOn") as? Bool ?? true
    }
}

// MARK: - Gerenciamento do Jogo
extension GameManager {
    
    func createGame() {
        self.game = Game(
            teams: [
                Team(name: "Equipe 1", cards: []),
                Team(name: "Equipe 2", cards: [])
            ],
            cards: cardManager.dbCards.map { Card(original: $0) },
            rounds: [Round(RoundNumber: 1)]
        )
    }
    
    func resetGame()  {
        currentTeamIndex = 0
        currentRoundId = 1
        createGame()
    }
    
    func getGameState() -> GameState {
        guard !game.teams.isEmpty else {
            return .error
        }
        let lastRound = currentRoundId == maxRoundNumbers
        let lastTeamHasPlayed = currentTeamIndex == game.teams.count - 1
        if lastRound {
            return lastTeamHasPlayed ? .gameOver : .nextTeam
        } else {
            return lastTeamHasPlayed ? .nextRound : .nextTeam
        }
    }
    
    func teamWithMostCards() -> String {
        let maxCards = game.teams.map(\.cards.count).max() ?? 0
        let teamsWithMaxCards = game.teams.filter { $0.cards.count == maxCards }
        
        switch teamsWithMaxCards.count {
        case 0:
            return "Não há times com cartas."// no cards
        case 1:
            return "\(teamsWithMaxCards.first?.name ?? "Desconhecido") venceu!" //winner
        default:
            return "Jogo Empatado!" //tie
        }
    }
}

// MARK: - Manipulação de Rodadas e Times
extension GameManager {
    
    func addTeam(_ team: Team) {
        game.teams.append(team)
    }
    
    func addRound() {
        guard currentRoundId < maxRoundNumbers else {
            return
        }
        currentTeamIndex = 0
        currentRoundId += 1
        game.rounds.append(Round(RoundNumber: currentRoundId))
    }
    
    func changeTeam() {
        print("Current Team Index era: \(currentTeamIndex)")
        currentTeamIndex = (currentTeamIndex + 1) % game.teams.count
        print("Current Team Index mudou para: \(currentTeamIndex)")
        skipCard()
    }
    
    func changeTeamName(team: Team, name: String) {
        if let index = game.teams.firstIndex(where: { $0.teamId == team.teamId }) {
            game.teams[index].name = name
        }
    }
    
    func removeTeam(team: Team) {
        if let index = game.teams.firstIndex(where: { $0.teamId == team.teamId }) {
            game.teams.remove(at: index)
        }
    }
}

// MARK: - Manipulação de Cartas
extension GameManager {
    
    func dealCard(answer: Bool, team: Team) async throws {
        guard let firstCard = game.cards.first else { return }
        
        let nextTeamIndex = (currentTeamIndex + 1) % game.teams.count
        let nextTeam = game.teams[nextTeamIndex]
        
        do {
            if answer {
                try giveCardToTeam(card: firstCard, team: team)
                print("A carta \(firstCard.keyWord) foi atribuída à equipe \(team.name)")
                if soundOn{
                    SoundManager.shared.playSound(fileName: "certaResposta", fileExtension: ".mp3")
                }
            } else {
                try giveCardToTeam(card: firstCard, team: nextTeam)
                if soundOn{
                    SoundManager.shared.playSound(fileName: "errou", fileExtension: ".mp3")
                }
                print("A carta \(firstCard.keyWord) foi atribuída à equipe \(nextTeam.name)")
            }
        } catch {
            
            throw GameManagerError.cardDealingFailed(underlyingError: error)
        }
    }
    
    func giveCardToTeam(card: Card, team: Team) throws {
        guard let teamIndex = game.teams.firstIndex(where: { $0.teamId == team.teamId }) else {
            throw GameManagerError.teamNotFound // Usa o enum definido
        }
        
        game.teams[teamIndex].cards.append(card)
        try removeCard(card) //Agora remove card chama o throws
    }
    
    func loadDefaultCards() {
        game.cards = cardManager.dbCards.map { Card(original: $0) }
        game.cards.shuffle()
    }
    
    func removeCard(_ card: Card) throws {
        if let index = game.cards.firstIndex(where: { $0 === card }) {
            game.cards.remove(at: index)
        } else {
            throw GameManagerError.cardNotFound
        }
    }
    
    func skipCard() {
        guard !game.cards.isEmpty else { return }
        let first = game.cards.removeFirst()
        game.cards.append(first)
    }
}
