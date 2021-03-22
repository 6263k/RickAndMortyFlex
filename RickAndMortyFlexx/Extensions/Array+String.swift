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
