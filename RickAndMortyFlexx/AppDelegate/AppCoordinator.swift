//
//  AppCoordinator.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 29.03.2021.
//

import UIKit

final class AppCoordinator {
  private let window: UIWindow?
  private let dependecies: AppDependecies
  
  private let rootNavigationController: UINavigationController = {
    let navigationController = UINavigationController()
    navigationController.navigationBar.isHidden = true
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.view.backgroundColor = .red
    return navigationController
  }()
  private var childCoorinators = [Coordinatable]()
  
  
  init(with window: UIWindow?, dependecies: AppDependecies) {
    self.window = window
    self.dependecies = dependecies
  }
  
  func start() {
    window?.rootViewController = rootNavigationController
    window?.makeKeyAndVisible()
    
    let tabBarCoordinator = BaseTabBarCoordinator(with: rootNavigationController, dependecies)
    tabBarCoordinator.start()
    childCoorinators.append(tabBarCoordinator)
  }
  
}
