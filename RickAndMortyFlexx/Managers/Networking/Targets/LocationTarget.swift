//
//  LocationTarget.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 20.03.2021.
//

import Moya


enum LocationTarget {
  case location(page: Int, name: String = "")
  case locationsWith(ids: [Int])
  case locationWith(id: Int)
}

extension LocationTarget: TargetType {
  var baseURL: URL {
    URL(string: "https://rickandmortyapi.com/api")!
  }
  
  var path: String {
    switch self {
    case .location(_, _):
      return "/location/"
    case .locationWith(let id):
      return "/location/" + String(id)
    case .locationsWith(let ids):
      return "/location/" + ids.toStringWith(separator: ",")
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
  
  var parameters: [String: Any]? {
    var params = [String: Any]()
    switch self {
    case let .location(page, name):
      params["page"] = page
      params["name"] = name
    default:
      break
    }
    return params
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    default:
      if let parameters = parameters {
        return .requestParameters(parameters: parameters, encoding: defaultParameterEncoding)
      }
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return ["Content-type":"application/json"]
  }
  
  
  
  
}