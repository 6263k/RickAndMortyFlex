//
//  RickAndMortyAPI.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 17.03.2021.
//

import Moya

enum CharacterTarget {
  case character(page: Int, name: String = "", status: CharacterStatus = .none, species: String = "", type: CharacterGender = .none)
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
    @unknown default:
      return ""
    }
  }
  
  var method: Method {
    switch self {
    default:
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
    default:
      break
    }
    return params
  }
  
  var task: Task {
    switch self {
    default:
      if let parameters = parameters {
        return .requestParameters(parameters: parameters, encoding: defaultParameterEncoding )
      }
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return ["Content-type":"application/json"]
  }
  
}


