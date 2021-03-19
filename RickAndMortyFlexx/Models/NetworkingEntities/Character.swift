//
//  Character.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import Foundation


struct CharacterModel: Codable {
  let id: Int
  let name: String
  let status: String
  let species: String
  let type: String
  let gender: String
  let origin: CharacterOirignModel
  let location: CharacterLocationModel
  let image: String
  let episode: [String]
  let url: String
  let created: String
}

struct CharacterInfoModel: Codable{
  let info: InfoModel
  let results: [CharacterModel]
}
struct CharacterLocationModel: Codable {
  let name: String
  let url: String
}

struct CharacterOirignModel: Codable {
  let name: String
  let url: String
}

enum CharacterStatus: String {
  case alive = "alive"
  case dead = "dead"
  case unknown = "unknown"
  case none = ""
}

enum CharacterGender: String {
  case female = "female"
  case male = "male"
  case genderless = "genderless"
  case unknown = "unknown"
  case none = ""
}
