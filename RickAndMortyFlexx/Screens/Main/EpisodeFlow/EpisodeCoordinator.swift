//
//  EpisodeCoordinator.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 18.04.2021.
//

import RxSwift

final class EpisodeCoordnatior: Coordinatable {
	enum Route {
		case episodeFeed
		case detailEpisode(id: Int)
		case characterWith(id: Int)
	}
	private let dependecies: AppDependecies
	
	var navigationController: UINavigationController = {
		let navigationController = UINavigationController()
		navigationController.tabBarItem.image = #imageLiteral(resourceName: "episodeFeedIcon")
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
		route(to: .episodeFeed, from: navigationController, with: SetTransition(isAnimated: false))
	}
	
	
	func route(to route: Route, from: UIViewController? = nil, with transition: Transition) {
		let fromVC = from ?? navigationController
		switch route {
			case .episodeFeed:
				routeToEpisodeFeed(from: fromVC, with: transition)
			case .detailEpisode(let id):
				routeToDetailEpisode(from: fromVC, to: id, with: transition)
			case .characterWith(let id):
				routeToCharacter(from: fromVC, to: id, with: transition)
		}
	}
	
	private func routeToEpisodeFeed(from vc: UIViewController, with transition: Transition) {
		let episodeFeedViewModel = EpisodeFeedViewModel(service: dependecies.rmService, coordinator: self)
		episodeFeedViewModel.coordinator = self
		guard let episodeFeedViewController = EpisodeFeedViewController.createWithStoryboard(Storyboard.main, with: episodeFeedViewModel) else { return }

		transition.open(episodeFeedViewController, from: vc, completion: nil)
	}
	
	private func routeToDetailEpisode(from vc: UIViewController, to episodeID: Int, with transition: Transition) {
		let episodeDetailViewModel = EpisodeDetailViewModel(service: dependecies.rmService, id: episodeID, coordinator: self)
		episodeDetailViewModel.coordinator = self
		guard let detailEpisodeVC = EpisodeDetailViewController.createWithStoryboard(Storyboard.main, with: episodeDetailViewModel) else { return }
		transition.open(detailEpisodeVC, from: vc, completion: nil)
	}
	
	private func routeToCharacter(from vc: UIViewController, to characterID: Int, with transition: Transition) {
		let characterCoodinator = CharacterCoordinator(dependecies: dependecies)
		characterCoodinator.setNavigationController(nc: navigationController)
		characterCoodinator.route(to: .detailCharacter(id: characterID), from: vc, with: transition)
	}
	
	func setNavigationController(nc: UINavigationController){
		navigationController = nc
	}

}

extension EpisodeCoordnatior {
	func showError(error: APIError) {
		ErrorView.showIn(viewController: navigationController, message: error.localizedDescription)
	}
}

