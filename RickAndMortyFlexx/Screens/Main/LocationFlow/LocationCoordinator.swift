//
//  CharacterCoordinator.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 31.03.2021.
//

import RxSwift

final class LocationCoordinator: Coordinatable {
	enum Route {
		case locationFeed
		case detailLocation(id: Int)
		case characterWith(id: Int)
	}
	private let dependecies: AppDependecies
	
	var navigationController: UINavigationController = {
		let navigationController = UINavigationController()
		navigationController.tabBarItem.image = #imageLiteral(resourceName: "locationFeedIcon")
		navigationController.navigationBar.isTranslucent = false
		navigationController.navigationBar.barTintColor = .rmDarkBlue
		
		
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
		route(to: .locationFeed, from: navigationController, with: SetTransition(isAnimated: false))
	}
	
	
	func route(to route: Route, from: UIViewController? = nil, with transition: Transition) {
		let fromVC = from ?? navigationController
		switch route {
			case .locationFeed:
				routeToLocationFeed(from: fromVC, with: transition)
			case .detailLocation(let id):
				routeToDetailLocation(from: fromVC, to: id, with: transition)
			case .characterWith(let id):
				routeToCharacter(from: fromVC, to: id, transition: transition)
		}
	}
	
	private func routeToLocationFeed(from vc: UIViewController, with transition: Transition) {
		let locationFeedViewModel = LocationFeedViewModel(service: dependecies.rmService, coordinator: self)
		locationFeedViewModel.coordinator = self
		guard let locationFeedViewController = LocationFeedViewController.createWithStoryboard(Storyboard.main, with: locationFeedViewModel) else { return }
		
		transition.open(locationFeedViewController, from: vc, completion: nil)
	}
	
	private func routeToDetailLocation(from vc: UIViewController, to locationID: Int, with transition: Transition) {
		let locationDetailViewModel = LocationDetailViewModel(service: dependecies.rmService, id: locationID, coordinator: self)
		locationDetailViewModel.coordinator = self
		guard let detailLocationrVC = LocationDetailViewController.createWithStoryboard(Storyboard.main, with: locationDetailViewModel) else { return }
		transition.open(detailLocationrVC, from: vc, completion: nil)
	}
	
	private func routeToCharacter(from vc: UIViewController, to characterdID: Int, transition: Transition ) {
		let characterCoordinator = CharacterCoordinator(dependecies: dependecies)
		characterCoordinator.setNavigationController(nc: navigationController)
		characterCoordinator.route(to: .detailCharacter(id: characterdID), from: vc, with: transition)
	}
	
	func setNavigationController(nc: UINavigationController) {
		navigationController = nc
	}
}

extension LocationCoordinator {
	func showError(error: APIError) {
		ErrorView.showIn(viewController: navigationController, message: error.localizedDescription)
	}
}

