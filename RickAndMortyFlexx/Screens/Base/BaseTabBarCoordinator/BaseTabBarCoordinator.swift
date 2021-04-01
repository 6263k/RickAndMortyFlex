//
//  BaseTabBarCoordinator.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 29.03.2021.
//

import RxSwift

final class BaseTabBarCoordinator: Coordinator {
  enum Route {
  }
  let navigationController: UINavigationController = {
    let navigationViewController = UINavigationController()
    navigationViewController.modalPresentationStyle = .fullScreen
    navigationViewController.modalTransitionStyle = .crossDissolve
    navigationViewController.navigationBar.isHidden = true
    navigationViewController.view.backgroundColor = .magenta
    return navigationViewController
  }()
  
  lazy var tabBarController: UITabBarController = {
    let tabBarController = UITabBarController()
    tabBarController.modalPresentationStyle = .fullScreen
    tabBarController.modalTransitionStyle = .crossDissolve
    tabBarController.view.backgroundColor = .blue
    return tabBarController
  }()
  
  private let dependecies: AppDependecies
  private let parentNavigationController: UINavigationController
  
  init(with navigationController: UINavigationController, _ dependecies: AppDependecies) {
    self.dependecies = dependecies
    self.parentNavigationController = navigationController
  }
  
  
  func start() {
    parentNavigationController.showAsync(navigationController, sender: nil)
    let characterCoordinator = CharacterCoordinator(navigationController, dependecies: dependecies)
    characterCoordinator.start()
    let character2Coordinator = CharacterCoordinator(navigationController, dependecies: dependecies)
    tabBarController.setViewControllers([characterCoordinator.navigationController, character2Coordinator.navigationController], animated: false)
    
    navigationController.setViewControllers([tabBarController], animated: false)
  }
  
  
  func route(to route: Route, with transition: Transition) {
    
  }
}
