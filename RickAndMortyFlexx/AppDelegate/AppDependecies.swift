//
//  AppDependecies.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 28.03.2021.
//

import Foundation
typealias HasDependecies = HasRMService

struct AppDependecies: HasDependecies {
  let rmService: RMService
}
