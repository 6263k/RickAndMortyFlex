//
//  APIClient.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 17.03.2021.
//

import Foundation

final class APIClient: APIManager {
  var session: URLSession
  
  init (configuration: URLSessionConfiguration) {
    self.session = URLSession(configuration: configuration)
  }
  
  convenience init() {
    self.init(configuration: .default)
  }
  
  //Characters
  func getAllCharacters(completion: @escaping (Result<[CharacterModel], Error>) ->Void) {
    var allCharacters = [CharacterModel]()
    let endpoint = RickAndMortyEndpoint.character
    guard let url = URL(string: endpoint.url) else {
      fatalError()
    }
    
    let request = URLRequest(url: url)
    performAPIRequest(with: request) { result in
      switch result {
      case .success(let data):
        if let infoModel: CharacterInfoModel = self.decodeJSONData(data: data) {
          allCharacters = infoModel.results
          let charaterDispatchGroup = DispatchGroup()
          
          for index in 2...infoModel.info.pages {
            charaterDispatchGroup.enter()
            self.getCharacterByPageNumber(pageNumber: index) {
              switch $0 {
              case .success(let characters):
                allCharacters.append(contentsOf: characters)
                charaterDispatchGroup.leave()
              case .failure(let error):
                completion(.failure(error))
              }
            }
          }
          charaterDispatchGroup.notify(queue: DispatchQueue.main) {
            completion(.success(allCharacters.sorted {$0.id < $1.id }))
          }
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func getCharacterByPageNumber(pageNumber: Int, completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
    let endpoint = RickAndMortyEndpoint.character
    guard let numberURL = URL(string: endpoint.pageURL + String(pageNumber)) else {
      fatalError()
    }
    let request = URLRequest(url: numberURL)
    
    performAPIRequest(with: request) { [ weak self ] result in
      switch result {
      case .success(let data):
        if let infoModel: CharacterInfoModel = self?.decodeJSONData(data: data) {
          completion(.success(infoModel.results))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func getCharacterByID(ids: [Int], completion: @escaping (Result<[CharacterModel], Error>) -> Void) {
    let endpoint = RickAndMortyEndpoint.character
    let stringIDs = ids.map { String($0) }
    guard let url = URL(string: endpoint.url + stringIDs.joined(separator: ",")) else {
      fatalError()
    }
    let request = URLRequest(url: url)
    performAPIRequest(with: request) {
      switch $0 {
      case .success(let data):
        if let characters: [CharacterModel] = self.decodeJSONData(data: data) {
          completion(.success(characters))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
