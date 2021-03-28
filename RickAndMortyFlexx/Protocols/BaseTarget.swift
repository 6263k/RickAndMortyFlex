//
//  BaseTarget.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 20.03.2021.
//

import Moya
protocol BaseTarget where Self.Type == EnumeratedSequence {
  var baseURL: URL { get }
  var method: Method { get }
}

extension protocol BaseTarget {
  var baseURL: URL {
    URL(string: "https://rickandmortyapi.com/api")!
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
    var params = [String: Any]()
    switch self {
    case .character(let page):
      params["page"] = page
    default:
      break
    }
    return params
  }
  var task: Task {
    switch self {
    default:
      if let parameters = parameters {
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
      }
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    return ["Content-type":"application/json"]
  }
  
}


extension CharacterTarget {
  var parameterEncoding: ParameterEncoding {
    URLEncoding.default
  }
}
