//
//  APIError.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 22.03.2021.
//

import Moya


enum APIError: Error {
  case invalidData
  case requestFailed
  case jsonConversationFailed
  case moyaError
  
  static func from(_ error: MoyaError) -> APIError {
    switch error {
    case .jsonMapping(_):
      return .jsonConversationFailed
    default:
      return .moyaError
    }
  }
}

extension APIError {
  public var localizedDescription: String {
    switch self {
    case .invalidData:
      return "Неверные данные"
    case .jsonConversationFailed:
      return "Не удалось переобразовать JSON в объект"
    case .requestFailed:
      return "Не удалось отправить запрос"
    case .moyaError:
      return "Какая-то моя ошибка, я не распарсил их ¯\\_(ツ)_/¯" 
    }
  }
}
