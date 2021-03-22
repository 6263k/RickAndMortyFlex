//
//  Single+Decodable.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 22.03.2021.
//

import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Result<Data, APIError> {
  func mapDecodable<D: Decodable>(from type: D.Type,
                                  decodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970) -> Single<Result<D, APIError>> {
    
    return flatMap { (element) -> Single<Result<D, APIError>> in
      switch element {
      case .success(let json):
        do {
          guard let obj = try json.decode(as: D.self, decodingStrategy) else {
            return .just(.failure(.invalidData)) }
          return .just(.success(obj))
        } catch let error {
          print(error)
          return .just(.failure(.jsonConversationFailed))
        }
        
      case .failure(let error):
        return .just(.failure(error))
      }
    }
  }
  
}


public extension Data {
  func decode<D: Decodable>(as type: D.Type, _ decodingStrategy: JSONDecoder.DateDecodingStrategy) throws -> D? {
    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = decodingStrategy
      return try decoder.decode(type, from: self)
    } catch let error {
      throw error
    }
  }
}
