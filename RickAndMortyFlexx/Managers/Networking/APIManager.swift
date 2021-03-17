//
//  ApiManager.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import Foundation

enum NetworkError: Error {
  case invalidResponse
  case apiError
  case decodingError
}

protocol APIManager {
  var session: URLSession { get }
}

extension APIManager {
  
  func performAPIRequest(with request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
    session.dataTask(with: request) { (data, response, error) in
      
      if error != nil {
        completion(.failure(.apiError))
        return
      }
      
      guard let response = response as? HTTPURLResponse,
            200..<300 ~= response.statusCode else {
        completion(.failure(.invalidResponse))
        return
      }
      
      if let data = data {
        completion(.success(data))
      }
    }.resume()
  }
  
  func decodeJSONData<T: Decodable>(data: Data) -> T? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(T.self, from: data)
      return decodedData
    } catch {
      return nil
    }
  }
}
