//
//  CharacterCoordinator.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 31.03.2021.
//

import RxSwift

final class CharacterCoordinator: Coordinatable {
  enum Route {
    case characterFeed
		case detailCharacter(id: Int)
  }
  private let dependecies: AppDependecies
  
  let navigationController: UINavigationController = {
    let navigationController = UINavigationController()
		navigationController.tabBarItem.image = #imageLiteral(resourceName: "characterFeedIcon")
		navigationController.navigationBar.isTranslucent = false
		navigationController.navigationBar.barTintColor = .rmDarkBlue
		
//		let backButton = UIBarButtonItem()
//		backButton.title = ""
//		navigationController.navigationBar.topItem?.backBarButtonItem = backButton
//		navigationController.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "AssetBackButton")
//		navigationController.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "AssetBackButton")
//		navigationController.setNavigationBarHidden(false, animated: false)
		
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithOpaqueBackground()
		navigationBarAppearance.backgroundColor = .rmDarkBlue
		navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
		navigationController.navigationBar.compactAppearance = navigationBarAppearance
		navigationController.navigationBar.standardAppearance = navigationBarAppearance
    return navigationController
  }()
  
  init (dependecies: AppDependecies) {
    self.dependecies = dependecies
    
  }
  func start() {
    route(to: .characterFeed, with: SetTransition(isAnimated: false))
  }
  
  
	func route(to route: Route, with transition: Transition) {
    switch route {
			case .characterFeed:
				routeToCharacterViewController(from: navigationController, with: transition)
			case .detailCharacter(let id):
				routeToCharacterDetailViewController(from: navigationController, to: id, with: transition)
    }
  }
  
	private func routeToCharacterViewController(from vc: UIViewController, with transition: Transition) {
    let characterFeedViewModel = CharacterFeedViewModel(service: dependecies.rmService, coordinator: self)
		characterFeedViewModel.coordinator = self
    guard let characterViewController = CharacterFeedViewController.createWithStoryboard(Storyboard.main, with: characterFeedViewModel) else { return }
		transition.open(characterViewController, from: vc, completion: nil)
  }
	
	private func routeToCharacterDetailViewController(from vc: UIViewController, to characterID: Int, with transition: Transition) {
		let characterDetailViewModel = CharacterDetailViewModel(service: dependecies.rmService, id: characterID, coordinator: self)
		characterDetailViewModel.coordinator = self
		guard let detailCharacterVC = CharacterDetailViewController.createWithStoryboard(Storyboard.main, with: characterDetailViewModel) else { return }
		transition.open(detailCharacterVC, from: vc, completion: nil)
	}
	
  
}

extension CharacterCoordinator {
	func showError(error: APIError) {
		ErrorView.showIn(viewController: navigationController, message: error.localizedDescription)
	}
}

