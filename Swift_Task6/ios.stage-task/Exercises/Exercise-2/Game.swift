//
//  Game.swift
//  DurakGame
//
//  Created by Дима Носко on 16.06.21.
//

import Foundation

protocol GameCompatible {
    var players: [Player] { get set }
}

struct Game: GameCompatible {
    var players: [Player]
}

extension Game {

    func defineFirstAttackingPlayer(players: [Player]) -> Player? {

		players
			.filter { !($0.hand?.filter { card in card.isTrump }.isEmpty ?? true) }
			.sorted { player1, player2  in

				let first = player1
					.hand?
					.filter { card in
						card.isTrump
					}
					.sorted(by: { card1, card2 in
						card1.value.rawValue < card2.value.rawValue
					})
					.first

				let second = player1
					.hand?
					.filter { $0.isTrump }
					.sorted { $0.value.rawValue < $1.value.rawValue }
					.first

				return first!.value.rawValue < second!.value.rawValue
			}
			.first
	}
}
