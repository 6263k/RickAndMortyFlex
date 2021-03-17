//
//  RickAndMortyAPI.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 17.03.2021.
//

import Foundation

enum RickAndMortyEndpoint {
  case character
  case location
  case episode
}

extension RickAndMortyEndpoint {
  var baseURL: String {
    return "https://rickandmortyapi.com/api"
  }
  
  var method: String {
    switch self {
    case .character, .location, .episode:
      return "GET"
    }
  }
  
  var path: String {
    switch self {
    case .character:
      return "/character/"
    case .location:
      return "/location/"
    case .episode:
      return "/episode/"
    @unknown default:
      return ""
    }
  }
  
  var url: String {
    return baseURL + path
  }
  var pageURL: String {
    return url + "?page="
  }
  
}
