//
//  Transition.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 29.03.2021.
//

import UIKit


protocol Transition {
  var isAnimated: Bool { get set }
  
  func open(_ viewController: UIViewController, from: UIViewController, completion: (() -> Void)?)
  func close(_ viewController: UIViewController, completion: (() -> Void)?)
}
