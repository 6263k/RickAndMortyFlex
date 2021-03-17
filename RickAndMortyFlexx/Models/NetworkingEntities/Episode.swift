//
//  Episode.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import Foundation


struct EpisodeModel: Codable {
  let id: Int
  let name: String
  let airDate: String
  let episode: String
  let characters: [String]
  let url: String
  let created: String
  
  enum  CodingKeys: String, CodingKey {
    case id, name, episode, characters, url, created
    case airDate = "air_date"
  }
}
