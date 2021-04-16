//
//  RickAndMortyAPI.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 17.03.2021.
//

import Moya

enum CharacterTarget {
  case character(page: Int, name: String = "", status: CharacterModel.CharacterStatus = .none, species: String = "", type: CharacterModel.CharacterGender = .none)
  case charactersWith(ids: [Int])
  case charaterWith(id: Int)
}

extension CharacterTarget: TargetType {
  var baseURL: URL {
    URL(string: "https://rickandmortyapi.com/api")!
  }
  
  var path: String {
    switch self {
    case .character(_, _, _, _, _):
      return "/character/"
    case .charaterWith(let id):
      return "/character/" + String(id)
    case .charactersWith(let ids):
      return "/character/" + ids.toStringWith(separator: ",")
    }
  }
  
  var method: Method {
    switch self {
    case .character, .charactersWith, .charaterWith:
      return .get
    }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var parameters: [String: Any]? {
    var params: [String: Any] = [:]
    switch self {
    case  let .character(page, name, status, species, type):
      params["page"] = page
      params["name"] = name
      params["status"] = status.rawValue
      params["species"] = species
      params["type"] = type.rawValue
    case .charaterWith, .charactersWith:
      break
    }
    return params
  }
  
  var task: Task {
    switch self {
    case .character, .charaterWith, .charactersWith:
      if let parameters = parameters {
				return .requestParameters(parameters: parameters, encoding: URLEncoding.default )
      }
      return .requestPlain
    }
    
    
  }
  
  var headers: [String : String]? {
    return ["Content-type":"application/json"]
  }
  
}



