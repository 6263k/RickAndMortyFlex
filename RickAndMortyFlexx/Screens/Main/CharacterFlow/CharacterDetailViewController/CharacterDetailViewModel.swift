//
//  DetailCharacterViewModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 08.04.2021.
//

import RxSwift
import RxCocoa

final class CharacterDetailViewModel: BaseViewModel {
	private let disposeBag = DisposeBag()
	private let id: Int
	private let service: RMService
	
	private var character: CharacterModel!
	
	var coordinator: CharacterCoordinator
	let snapshot = BehaviorRelay<CharacterDetailViewController.Snapshot>(value: CharacterDetailViewController.Snapshot())
	let isLoading = BehaviorRelay<Bool>(value: false)
	
	init(service: RMService, id: Int, coordinator: CharacterCoordinator) {
		self.service = service
		self.id = id
		self.coordinator = coordinator
		super.init()
	}
	
	override func setupModel() {
		requestData()
		
		super.setupModel()
	}
	
	private func requestData() {
		isLoading.accept(true)
		
		service.requestCharacterWithHisData(by: id)
			.catchAndReturn(.failure(.requestFailed))
			.subscribe(onNext: {[weak self] result in
				switch result {
					case .success(let character):
						self?.character = character
						self?.createSnapshot()
					case .failure(let error):
						print(error.localizedDescription)
						self?.coordinator.showError(error: error)
				}
				self?.isLoading.accept(false)
			})
			.disposed(by: disposeBag)
	}
	
	private func createSnapshot() {
		var snapshot = CharacterDetailViewController.Snapshot()
		snapshot.appendSections([.characterDetail, .episodes])
		
		let characterDetailCellModel = CharacterDetailCellModel(with: character)
		characterDetailCellModel.originButtonTapped = { [weak self] in
			let transition = PushTransition(isAnimated: true)
			self?.coordinator.route(to: .routeToLocation(id: characterDetailCellModel.characterOrigin.id), with: transition)
		}
		characterDetailCellModel.locationButtonTapped = { [weak self] in
			let transition = PushTransition(isAnimated: true)
			self?.coordinator.route(to: .routeToLocation(id: characterDetailCellModel.characterLocation.id), with: transition)
		}
		
		snapshot.appendItems([characterDetailCellModel], toSection: .characterDetail)
		
		let episodeCellModels = character.episode.toArray()
			.map {EpisodeCharacterCellModel(with: $0)}
		
		for episodeModel in episodeCellModels {
			episodeModel.onCellTapped = { [weak self] in
				let transition = PushTransition(isAnimated: true)
				self?.coordinator.route(to: .routeToEpisode(id: episodeModel.id), with: transition)
			}
		}
		
		snapshot.appendItems(episodeCellModels, toSection: .episodes)
		self.snapshot.accept(snapshot)
	}
	
}

