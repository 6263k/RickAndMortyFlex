//
//  Routable.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 29.03.2021.
//

import Foundation


protocol Routable {
  associatedtype Route
  
  func route(to route: Route, with transition: Transition)
}
