//
//  Location.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import Foundation
import RealmSwift

class LocationModel: Object, IDInitable, Decodable {
  @objc dynamic var id: Int = Int.max
  @objc dynamic var name: String = "Unknown ¯\\_(ツ)_/¯"
  @objc dynamic var type: String = ""
  @objc dynamic var dimension: String = ""
  let characters = List<CharacterModel>()
  @objc dynamic var url: String = ""
  
  private var _residents: [String]?
  
  enum CodingKeys: String, CodingKey {
    case id, name, type, dimension, url
    case _residents = "residents"
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    type = try container.decode(String.self, forKey: .type)
    dimension = try container.decode(String.self, forKey: .dimension)
    url = try container.decode(String.self, forKey: .url)
    _residents = try container.decode([String]?.self, forKey: ._residents)
    super.init()
  }
  
  required override init() {
    super.init()
  }
  
  required init(id: Int) {
    self.id = id
    super.init()
  }
  
  override class func primaryKey() -> String? {
    return "id"
  }
  
  func getResidentsIDFromAPI() -> [Int]? {
    var IDs = [Int]()
    guard let characters = _residents else { return nil }
    characters.forEach { character in
      if let characterID = character.stringToURLIDcompnent() {
        IDs.append(characterID)
      }
    }
    return IDs
  }
  
}
