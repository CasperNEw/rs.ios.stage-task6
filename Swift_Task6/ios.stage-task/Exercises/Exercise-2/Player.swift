//
//  Player.swift
//  DurakGame
//
//  Created by Дима Носко on 15.06.21.
//

import Foundation

protocol PlayerBaseCompatible {
    var hand: [Card]? { get set }
}

final class Player: PlayerBaseCompatible {
    var hand: [Card]?

    func checkIfCanTossWhenAttacking(card: Card) -> Bool {
		hand?.contains(where: { $0.value.rawValue == card.value.rawValue }) ?? false
	}

    func checkIfCanTossWhenTossing(table: [Card: Card]) -> Bool {

		let inKeys = !(hand?.filter { card in
						table.keys.map({ $0.value.rawValue
						})
						.contains(card.value.rawValue) }
						.isEmpty ?? true)

		let inValues = !(hand?.filter { card in
							table.values.map({ $0.value.rawValue
							})
							.contains(card.value.rawValue) }
							.isEmpty ?? true)

		return inKeys || inValues
    }
}
