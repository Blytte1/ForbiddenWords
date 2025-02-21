protocol GameRouterProtocol {
    var path: [GameScreen] { get set }
    var currentScreen: GameScreen { get set }
    
    func navigateTo(_ screen: GameScreen)
    func popToRoot()
}