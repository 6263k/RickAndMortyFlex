//
//  Array+String.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 20.03.2021.
//

import Foundation


extension Array where Element == Int {
  @inlinable public func toStringWith(separator: String) -> String {
    return self.map { String($0) }.joined(separator: separator)
  }
}

extension Array where Element: Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            guard !uniqueValues.contains(item) else { return }
            uniqueValues.append(item)
        }
        return uniqueValues
    }
}


extension Int {
	func mapPageToIDs() -> [Int] {
		return Array(
			(self - 1) * 20 + 1 ... self * 20
		)
		
	}
}

extension Array where Element == APIError? {
	var error: APIError? {
		return compactMap { $0 }.first
	}
}

extension Result {
	var error: APIError? {
		guard case .failure(let error) = self else { return nil}
		return error as? APIError
	}
	
}
