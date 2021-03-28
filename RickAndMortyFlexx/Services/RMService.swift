//
//  RMService.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 28.03.2021.
//

import RxSwift

final class RMService{
  private let apiManager: APIManager
  private let dbManager: DBManager
  
  private let disposeBag = DisposeBag()
  
  init(apiManager: APIManager, dbManager: DBManager) {
    self.apiManager = apiManager
    self.dbManager = dbManager
  }
}
