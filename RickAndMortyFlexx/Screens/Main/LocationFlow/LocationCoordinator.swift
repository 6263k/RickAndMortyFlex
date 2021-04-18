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
	}
	private let dependecies: AppDependecies
	
	let navigationController: UINavigationController = {
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
	
	
	func route(to route: Route, from: UIViewController, with transition: Transition) {
		switch route {
			case .locationFeed:
				routeToLocationFeed(from: from, with: transition)
			case .detailLocation(let id):
				routeToDetailLocation(from: from, to: id, with: transition)
		}
	}
	
	private func routeToLocationFeed(from vc: UIViewController, with transition: Transition) {
		let locationFeedViewModel = LocationFeedViewModel(service: dependecies.rmService, coordinator: self)
		locationFeedViewModel.coordinator = self
		guard let locationFeedViewController = LocationFeedViewController.createWithStoryboard(Storyboard.main, with: locationFeedViewModel) else { return }
		
		transition.open(locationFeedViewController, from: vc, completion: nil)
	}
	
	private func routeToDetailLocation(from vc: UIViewController, to characterID: Int, with transition: Transition) {
		let locationDetailViewModel = LocationDetailViewModel(service: dependecies.rmService, id: characterID, coordinator: self)
		locationDetailViewModel.coordinator = self
		guard let detailLocationrVC = LocationDetailViewController.createWithStoryboard(Storyboard.main, with: locationDetailViewModel) else { return }
		transition.open(detailLocationrVC, from: vc, completion: nil)
	}
	
	
}

extension LocationCoordinator {
	func showError(error: APIError) {
		ErrorView.showIn(viewController: navigationController, message: error.localizedDescription)
	}
}

