import Foundation

class CoronaClass {

	struct FreeSpace {
		let place: Int
		let leftSpace: Int
		let rightSpace: Int

		var minSpace: Int {
			min(leftSpace, rightSpace)
		}
	}

	public var seats = [Int]()

	private let desksCount: Int
	private let spaceMax: Int

	init(n: Int) {
		desksCount = n
		spaceMax = n
	}

	public func seat() -> Int {
		guard seats.count < desksCount else { return -1 }
		guard !seats.isEmpty else {
			seats.append(0)
			return 0
		}

		var candidates: [FreeSpace] = []
		for index in seats.indices {
			let currentStudentDesk = seats[index]

			if index > 0 {
				let previusStudentDesk = seats[index - 1]
				if currentStudentDesk - previusStudentDesk > 1 {
					let doubleDesk = (Double(currentStudentDesk + previusStudentDesk) / 2).rounded(.up)
					candidates.append(FreeSpace(place: Int(doubleDesk),
												leftSpace: Int(doubleDesk) - previusStudentDesk - 1,
												rightSpace: currentStudentDesk - Int(doubleDesk) - 1))
				}
			} else if index == 0, seats[index] > 0 {
				candidates.append(FreeSpace(place: 0,
											leftSpace: spaceMax,
											rightSpace: currentStudentDesk - 1))
			}

			if index + 1 < seats.count {
				let nextStudentDesk = seats[index + 1]
				if nextStudentDesk - currentStudentDesk > 1 {
					var doubleDesk = (Double(nextStudentDesk + currentStudentDesk) / 2)
					doubleDesk.round(.down)

					candidates.append(FreeSpace(place: Int(doubleDesk),
												leftSpace: Int(doubleDesk) - currentStudentDesk - 1,
												rightSpace: nextStudentDesk - Int(doubleDesk) - 1))
				}
			} else if index == seats.count - 1, seats[index] < desksCount - 1 {
				candidates.append(FreeSpace(place: desksCount - 1,
											leftSpace: desksCount - 1 - currentStudentDesk - 1,
											rightSpace: spaceMax))

			}
		}

		let preSort = candidates
			.sorted { $0.minSpace > $1.minSpace }
			.filter { !seats.contains($0.place) }

		let suitableMinSpace = preSort.first?.minSpace

		let seat = preSort
			.filter { $0.minSpace == suitableMinSpace }
			.sorted { $0.place < $1.place }
			.first?
			.place

		if let realSeat = seat {
			seats.append(realSeat)
			seats.sort()
			return realSeat
		}

		return -1
	}

	public func leave(_ p: Int) {
		seats.removeAll { $0 == p }
	}
}
