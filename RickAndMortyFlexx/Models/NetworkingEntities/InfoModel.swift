//
//  InfoModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 17.03.2021.
//

import Foundation

struct InfoModel: Codable {
  let count: Int
  let pages: Int
  let next: String?
  let prev: String?
}
