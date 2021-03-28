//
//  AppAssembly.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 28.03.2021.
//

import Foundation

enum AppAssembly {
  static func assembly() -> AppDependecies {
    let apiManager = APIManager()
    guard let dbManager = DBManager() else {
      print("DataBase is not available")
      fatalError()
    }
    
    let rmService = RMService(apiManager: apiManager, dbManager: dbManager)
    
    return AppDependecies(rmService: rmService)
  }
}
