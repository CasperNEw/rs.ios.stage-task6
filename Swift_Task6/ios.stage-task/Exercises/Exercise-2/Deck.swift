import Foundation

protocol DeckBaseCompatible: Codable {
    var cards: [Card] {get set}
    var type: DeckType {get}
    var total: Int {get}
    var trump: Suit? {get}
}

enum DeckType:Int, CaseIterable, Codable {
    case deck36 = 36
}

struct Deck: DeckBaseCompatible {

    //MARK: - Properties

    var cards = [Card]()
    var type: DeckType
    var trump: Suit?

    var total:Int {
        return type.rawValue
    }
}

extension Deck {

    init(with type: DeckType) {
        self.type = type
		switch type {
		case .deck36:
			cards = createDeck(suits: Suit.allCases, values: Value.allCases)
		}
    }

    public func createDeck(suits:[Suit], values:[Value]) -> [Card] {

		let values = values.sorted { $0.rawValue < $1.rawValue }
		return suits
			.sorted(by: { $0.rawValue < $1.rawValue })
			.flatMap { suit in
				values.map { Card(suit: suit, value: $0) }
			}
	}

	public mutating func shuffle() {
		cards.shuffle()
    }

	public mutating func defineTrump() {
		trump = cards.last?.suit
		cards.enumerated().forEach {
			cards[$0.offset].isTrump = $0.element.suit == trump
		}
    }

	public mutating func initialCardsDealForPlayers(players: [Player]) {
		players.forEach {
			var suitableCards: [Card?] = []
			for _ in 1...6 {
				suitableCards.append(cards.popLast())
			}
			$0.hand = suitableCards.compactMap { $0 }
		}
	}

	public mutating func setTrumpCards(for suit:Suit) {
		trump = suit
		cards.enumerated().forEach {
			cards[$0.offset].isTrump = $0.element.suit == trump
		}
    }
}

