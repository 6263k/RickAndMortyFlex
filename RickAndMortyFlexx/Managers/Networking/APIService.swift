//
//  APIClient.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 17.03.2021.
//

import Alamofire

final class APIService: APIManager {
  var session: Session
  
  init (configuration: URLSessionConfiguration) {
    self.session = Session(configuration: configuration)
  }
  
  convenience init() {
    self.init(configuration: URLSessionConfiguration.af.default)
  }
  
  //Characters
  func getCharacterByIDs(ids: [Int], completion: @escaping(Result<[CharacterModel], AFError>) -> Void) {
    let url = RickAndMortyEndpoint.character.url
    let stringIDs = ids.map { String($0) }.joined(separator: ",")
    let finalURL = url.appending(stringIDs)
    
    session.request(finalURL, method: .get)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseDecodable(of: [CharacterModel].self) { (response) in
        switch response.result {
        case .success(let characters):
          completion(.success(characters))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
  func getCharacterByID(id: Int, completion: @escaping(Result<CharacterModel, AFError>) -> Void) {
    let url = RickAndMortyEndpoint.character.url + String(id)
    session.request(url, method: .get)
      .validate(statusCode: 200..<300)
      .validate(contentType: ["application/json"])
      .responseDecodable(of: CharacterModel.self) { (response) in
        switch response.result {
        case .success(let character):
          completion(.success(character))
        case let .failure(error):
          completion(.failure(error))
        }
      }
  }
  
  func getCharactersByPage(page: Int, completion: @escaping (Result<[CharacterModel], AFError>) -> Void) {
    let url = RickAndMortyEndpoint.character.pageURL + String(page)
    AF.request(url, method: .get)
      .validate()
      .responseDecodable(of: CharacterInfoModel.self) { response in
        switch response.result {
        case .success(let infoModel):
          completion(.success(infoModel.results))
        case . failure(let error):
          completion(.failure(error))
        }
      }
  }
  
  func getAllCharacters(completion: @escaping (Result<[CharacterModel], AFError>) -> Void) {
    let allDataURL = RickAndMortyEndpoint.character.url
    var allCharacters: [CharacterModel] = []
    AF.request(allDataURL)
      .validate()
      .responseDecodable(of: CharacterInfoModel.self) { [ weak self ] response in
        switch response.result {
        case .success(let info):
          let dispatchGroup = DispatchGroup()
          allCharacters.append(contentsOf: info.results)
          for page in 2...info.info.pages {
            dispatchGroup.enter()
            self?.getCharactersByPage(page: page) { result in
              switch result {
              case .success(let characters):
                allCharacters.append(contentsOf: characters)
                dispatchGroup.leave()
              case .failure(let error):
                completion(.failure(error))
              }
            }
            dispatchGroup.notify(queue: .main) {
              completion(.success(allCharacters.sorted {$0.id < $1.id }))
            }
          }
        case .failure(let error):
          completion(.failure(error))
        }
      }
  }
    
}
