//
//  CharacterCoordinator.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 31.03.2021.
//

import RxSwift

final class CharacterCoordinator: Coordinatable {
  enum Route {
    case character
  }
  private let dependecies: AppDependecies
  
  let navigationController: UINavigationController = {
    let navigationController = UINavigationController()
    navigationController.tabBarItem.title = "HUY"
    navigationController.view.backgroundColor = .black
    return navigationController
  }()
  
  init (dependecies: AppDependecies) {
    self.dependecies = dependecies
    
  }
  func start() {
    route(to: .character, with: SetTransition(isAnimated: false))
  }
  
  
  func route(to route: Route, with transition: Transition) {
    switch route {
    case .character:
      routeToCharacterViewController(from: navigationController, with: transition)
    }
  }
  
  private func routeToCharacterViewController(from vc: UIViewController, with transition: Transition) {
    let characterViewModel = CharacterViewModel()
    guard let characterViewController = CharacterViewController.createWithStoryboard(Storyboard.main, with: characterViewModel) else { return }
		transition.open(characterViewController, from: vc, completion: nil)
  }

  
}
