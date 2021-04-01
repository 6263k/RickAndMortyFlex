//
//  Coordinatable.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 29.03.2021.
//

import UIKit

protocol Coordinatable {
  var navigationController: UINavigationController { get }
  
  func start()
}
