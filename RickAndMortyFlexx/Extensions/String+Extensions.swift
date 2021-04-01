//
//  String+ID.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 27.03.2021.
//

import Foundation


extension String {
  @inlinable public func stringToURLIDcompnent() -> Int? {
    if let url = URL(string: self) {
      return Int(url.lastPathComponent)
    }
    return nil
  }
}
