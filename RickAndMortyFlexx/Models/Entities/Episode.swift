//
//  Episode.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import Foundation
import RealmSwift

class EpisodeModel: Object, IDInitable, Decodable  {
  @objc dynamic var id: Int = Int.max
  @objc dynamic var name: String = ""
  @objc dynamic var airDate: String = ""
  @objc dynamic var episode: String = ""
  let characters = List<CharacterModel>()
  @objc dynamic var url: String = ""
  
  private var _characters: [String]?
  
  enum  CodingKeys: String, CodingKey {
    case id, name, episode, url, created
    case airDate = "air_date", _characters = "characters"
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    airDate = try container.decode(String.self, forKey: .airDate)
    episode = try container.decode(String.self, forKey: .episode)
    url = try container.decode(String.self, forKey: .url)
    _characters = try container.decode([String]?.self, forKey: ._characters)
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
  
  func getCharactersIDFromAPI() -> [Int]? {
    var IDs = [Int]()
    guard let characters = _characters else { return nil }
    characters.forEach { character in
      if let characterID = character.stringToURLIDcompnent() {
        IDs.append(characterID)
      }
    }
    return IDs
  }
}
