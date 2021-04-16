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

	let tabBarController: UITabBarController = {
    let tabBarController = UITabBarController()
    tabBarController.modalPresentationStyle = .fullScreen
		tabBarController.tabBar.isTranslucent = false
		tabBarController.view.backgroundColor = .rmCyan
		tabBarController.tabBar.tintColor = .rmCyan
		tabBarController.tabBar.barTintColor = .rmDarkBlue
    return tabBarController
  }()
  
  private let dependecies: AppDependecies
  private let parentNavigationController: UINavigationController
  
  init(with navigationController: UINavigationController, _ dependecies: AppDependecies) {
    self.dependecies = dependecies
    self.parentNavigationController = navigationController
  }
  
  
  func start() {
		
		let characterCoordinator = CharacterCoordinator(dependecies: dependecies)
		characterCoordinator.start()
		tabBarController.setViewControllers([characterCoordinator.navigationController], animated: false)
    
		parentNavigationController.pushViewController(tabBarController, animated: false)
  }

  func route(to route: Route, with transition: Transition) {
    
  }
}
