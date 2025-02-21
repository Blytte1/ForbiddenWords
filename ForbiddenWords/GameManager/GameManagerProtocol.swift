protocol GameManagerProtocol {
    var game: Game? { get }
    var maxRoundNumbers: Int { get }
    var currentTeamIndex: Int { get }
    var currentRoundIndex: Int { get }
    
    func createGame(teams: [Team])
    func getWonCard(card: Card, team: Team) async throws
    func getLostCard(card: Card, team: Team) async throws
    func changeTeam() async throws
    func addTeam(_ team: Team) async throws
    func shuffleTeamsOrder() async throws
    func removeCard(_ card: Card) async throws
    func getDefaultCards() async throws
    func addRound() async throws
    func appendCardToTeam(card: Card, team: Team) async throws
    func teamWithMostCards() async throws -> String
}