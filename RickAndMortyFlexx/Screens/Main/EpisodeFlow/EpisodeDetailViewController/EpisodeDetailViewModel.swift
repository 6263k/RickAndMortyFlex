//
//  EpisodeDetailViewModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 18.04.2021.
//

import RxSwift
import RxCocoa

final class EpisodeDetailViewModel: BaseViewModel {
	private let disposeBag = DisposeBag()
	private let id: Int
	private let service: RMService
	
	private var episode: EpisodeModel!
	
	var coordinator: EpisodeCoordnatior
	let snapshot = BehaviorRelay<EpisodeDetailViewController.Snapshot>(value: EpisodeDetailViewController.Snapshot())
	let isLoading = BehaviorRelay<Bool>(value: false)
	
	init(service: RMService, id: Int, coordinator: EpisodeCoordnatior) {
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
		
		service.requestEpisodeWithItsData(by: id)
			.subscribe(onNext: {[weak self] result in
				switch result {
					case .success(let episode):
						self?.episode = episode
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
		var snapshot = EpisodeDetailViewController.Snapshot()
		snapshot.appendSections([.episodeHeader, .charactersInEpisode])
		
		let episodeDetailCellModel = EpisodeDetailCellModel(with: episode)
		snapshot.appendItems([episodeDetailCellModel], toSection: .episodeHeader)
		
		let characterCellModels = episode.characters.toArray()
			.map {LocationCharacterCellModel(with: $0)}
		
		snapshot.appendItems(characterCellModels, toSection: .charactersInEpisode)
		
		self.snapshot.accept(snapshot)
	}
	
}

