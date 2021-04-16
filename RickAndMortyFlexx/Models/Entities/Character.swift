//
//  Character.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import Foundation
import Realm
import RealmSwift



class CharacterModel: Object, IDInitable, Decodable {
  @objc dynamic var id: Int = Int.max
  @objc dynamic var name: String = ""
  @objc dynamic var species: String = ""
  @objc dynamic var type: String = ""
  @objc dynamic var image: String = ""
  @objc dynamic var url: String = ""
  @objc dynamic private var _status: String = CharacterStatus.none.rawValue
  @objc dynamic var _gender: String = CharacterGender.none.rawValue
  
  let episode = List<EpisodeModel>()
  
  
  @objc dynamic var origin: LocationModel? = LocationModel()
  @objc dynamic var location: LocationModel? = LocationModel()
  
  var status: CharacterStatus {
    get { return CharacterStatus(rawValue: _status)! }
    set { _status = newValue.rawValue}
  }
  var gender: CharacterGender {
    get { return CharacterGender(rawValue: _gender)! }
    set { _gender = newValue.rawValue }
  }
  
  private var _location: CharacterLocationModel?
  private var _origin: CharacterLocationModel?
  private var _episode: [String]?
  
  
  enum CharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    case none = ""
  }

  enum CharacterGender: String, Decodable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
    case none = ""
  }
  
  enum CodingKeys: String, CodingKey {
    case id, name, species, type, image, url
    case _status = "status", _gender = "gender", _location = "location", _origin = "origin", _episode = "episode"
  }
  
  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    species = try container.decode(String.self, forKey: .species)
    type = try container.decode(String.self, forKey: .type)
    image = try container.decode(String.self, forKey: .image)
    url = try container.decode(String.self, forKey: .url)
    _status = try container.decode(String.self, forKey: ._status)
    _gender = try container.decode(String.self, forKey: ._gender)
    _location = try container.decode(CharacterLocationModel?.self, forKey: ._location)
    _origin = try container.decode(CharacterLocationModel?.self, forKey: ._origin)
    _episode = try container.decode([String]?.self, forKey: ._episode)
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
  
  func getLocationIDFromAPI() -> Int? {
    return _location?.url.stringToURLIDcompnent()
  }
  
  func getOriginIDFromAPI() -> Int? {
    return _origin?.url.stringToURLIDcompnent()
  }
  
  func getEpisodesIDFromAPI() -> [Int]? {
    var IDs = [Int]()
    guard let episodes = _episode else { return nil }
    episodes.forEach { episode in
      if let episodeID = episode.stringToURLIDcompnent() {
        IDs.append(episodeID)
      }
    }
    return IDs
  }
  
}

struct CharacterInfoModel: Decodable {
  let info: InfoModel
  let results: [CharacterModel]
}

struct CharacterLocationModel: Decodable {
  let name: String
  let url: String
}

