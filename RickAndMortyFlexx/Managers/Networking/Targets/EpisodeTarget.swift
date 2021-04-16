//
//  EpisodeTarget.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 20.03.2021.
//

import Moya


enum EpisodeTarget {
  case episode(page: Int, name: String)
  case episodesWith(ids: [Int])
  case episodeWith(id: Int)
}

extension EpisodeTarget: TargetType {
  
  var baseURL: URL {
    URL(string: "https://rickandmortyapi.com/api")!
  }
  
  var path: String {
    switch self {
    case .episode(_, _):
      return "/episode/"
    case .episodeWith(let id):
      return "/episode/" + String(id)
    case .episodesWith(let ids):
      return "/episode/" + ids.toStringWith(separator: ",")
    }
  }
  
  var method: Method {
    switch self {
    case .episode, .episodeWith, .episodesWith:
      return .get
    }
  }
  
  var parameters: [String: Any]? {
    var params = [String: Any]()
    switch self {
    case let .episode(page, name):
      params["page"] = page
      params["name"] = name
    case .episodeWith, .episodesWith:
      break
    }
    return params
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
    case .episode, .episodeWith, .episodesWith:
      if let parameters = parameters {
				return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
      }
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return ["Content-type":"application/json"]
  }
}
