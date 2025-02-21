import Foundation

// CardsManager para gerenciar cartas e suas categorias
class CardsManager {
    private var cards: [Card] = []
    private var cardCategories: [String] = []
    
    init() {
        loadCategories()
        loadCards()
    }

    // Método para carregar todas as categorias existentes em CardCategory
    private func loadCategories() {
        cardCategories = CardCategory.allCases.map { $0.rawValue.uppercased() }
    }
    
    // Método para carregar todas as cartas do DummyData e preencher suas categorias
    private func loadCards() {
        for card in DummyData.cards {
            var categories: [String] = []

            // Verifica a categoria de cada carta baseada nos filtros do DummyData
            if DummyData.objectsIDs.contains(card.id) {
                categories.append(CardCategory.objects.rawValue.uppercased())
            }
            if DummyData.placesIDs.contains(card.id) {
                categories.append(CardCategory.places.rawValue.uppercased())
            }
            if DummyData.colorsIDs.contains(card.id) {
                categories.append(CardCategory.colors.rawValue.uppercased())
            }
            if DummyData.animalsIDs.contains(card.id) {
                categories.append(CardCategory.animals.rawValue.uppercased())
            }
            if DummyData.foodIDs.contains(card.id) {
                categories.append(CardCategory.food.rawValue.uppercased())
            }
            if DummyData.professionsIDs.contains(card.id) {
                categories.append(CardCategory.professions.rawValue.uppercased())
            }
            if DummyData.gamesAndSportsIDs.contains(card.id) {
                categories.append(CardCategory.gamesAndSports.rawValue.uppercased())
            }
            if DummyData.eventsIDs.contains(card.id) {
                categories.append(CardCategory.events.rawValue.uppercased())
            }
            if DummyData.emotionsIDs.contains(card.id) {
                categories.append(CardCategory.emotions.rawValue.uppercased())
            }
            if DummyData.abstractConceptsIDs.contains(card.id) {
                categories.append(CardCategory.abstractConcepts.rawValue.uppercased())
            }
            if DummyData.peopleIDs.contains(card.id) {
                categories.append(CardCategory.people.rawValue.uppercased())
            }

            // Atribui as categorias à carta
            var cardWithCategories = card
            cardWithCategories.categories = Array(Set(categories)) // Remove duplicatas, se houver
            cards.append(cardWithCategories)
        }
    }
    
    // Método para inserir uma nova categoria a uma carta
    func addCategory(toCardId id: Int, category: String) {
        guard let cardIndex = cards.firstIndex(where: { $0.id == id }) else {
            print("Carta com ID \(id) não encontrada.")
            return
        }

        let categoryUpper = category.uppercased()
        if !cards[cardIndex].categories.contains(categoryUpper) && cardCategories.contains(categoryUpper) {
            cards[cardIndex].categories.append(categoryUpper)
        } else {
            print("Categoria já existe ou não é uma categoria válida.")
        }
    }

    // Método para obter todas as cartas
    func getAllCards() -> [Card] {
        return cards
    }

    // Método para obter todas as categorias
    func getAllCategories() -> [String] {
        return cardCategories
    }
}
