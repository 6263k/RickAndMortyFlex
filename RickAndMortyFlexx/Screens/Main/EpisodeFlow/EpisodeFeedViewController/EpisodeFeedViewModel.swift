//
//  EpisodeFeedViewModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 18.04.2021.
//

import RxSwift
import RxCocoa

final class EpisodeFeedViewModel: BaseViewModel {
	private let disposeBag = DisposeBag()
	private let service: RMService
	
	var coordinator: EpisodeCoordnatior
	
	private var allEpisodes: [EpisodeModel] = []
	private var filteredEpisodes: [EpisodeModel] = []
	private var currentPage = 1
	private var endReached = false
	
	let searchText = PublishSubject<String>()
	let snapshot = BehaviorRelay<EpisodeFeedViewController.Snapshot>(value: EpisodeFeedViewController.Snapshot())
	let isLoading = BehaviorRelay<Bool>(value: false)
	private var searching = false
	
	init(service: RMService, coordinator: EpisodeCoordnatior) {
		self.service = service
		self.coordinator = coordinator
		super.init()
	}
	
	override func setupModel() {
		requestData()
		
		isLoading
			.subscribe(onNext: { [weak self] (state) in
				self?.createSnapshot()
			})
			.disposed(by: disposeBag)
		
		searchText
			.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
			.distinctUntilChanged()
			.flatMap { [weak self] (query) -> Observable<[EpisodeModel]> in
				self?.searching = query.count >= 1
				if query.count <= 1 {
					return .just([])
				}
				return self?.service.filterEpisodes(query: query)  ?? .just([])
			}
			.subscribe(onNext: { [weak self] episodes in
				self?.filteredEpisodes = episodes
				self?.createSnapshot()
			})
			.disposed(by: disposeBag)
		
		super.setupModel()
	}
	
	func requestData() {
		isLoading.accept(true)
		
		service.getEpisodes(by: currentPage.mapPageToIDs())
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] result in
				
				switch result {
					case .success(let models):
						self?.endReached = models.count < 20 ? false : true
						self?.allEpisodes.append(contentsOf: models)
					case .failure(let error):
						print(error.localizedDescription)
						self?.coordinator.showError(error: error)
				}
				self?.isLoading.accept(false)
			})
			.disposed(by: disposeBag)
	}
	
	func createSnapshot() {
		var snapshot = EpisodeFeedViewController.Snapshot()
		snapshot.appendSections([.episodeFeed])
		
		
		let episodeToShow = searching ? filteredEpisodes : allEpisodes
		//Location Cell
		let episodeCellModels: [EpisodeCharacterCellModel] = episodeToShow
			.map { EpisodeCharacterCellModel(with: $0) }
		
		episodeCellModels.forEach { [weak self] episode in
			guard let self = self else { return }
			episode.onCellTapped = {
				let transition = PushTransition(isAnimated: true)
				self.coordinator.route(to: .detailEpisode(id: episode.id),
															 from: self.coordinator.navigationController,
															 with: transition)
			}
		}
		snapshot.appendItems(episodeCellModels, toSection: .episodeFeed)
		
		
		//		Loading Cell
		if isLoading.value {
			snapshot.appendSections([.loadingCell])
			let loadingCellModel = LoadingCellModel()
			snapshot.appendItems([loadingCellModel], toSection: .loadingCell)
		}
		
		self.snapshot.accept(snapshot)
	}
	
	func loadMoreData() {
		if isLoading.value || searching || allEpisodes.isEmpty || !endReached { return }
		currentPage += 1
		requestData()
	}
	
}
