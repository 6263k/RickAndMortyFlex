//
//  ChatacterViewModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 31.03.2021.
//

import RxSwift
import RxCocoa


final class LocationFeedViewModel: BaseViewModel {
	private let disposeBag = DisposeBag()
	private let service: RMService
	
	var coordinator: LocationCoordinator
	
	private var allLocations: [LocationModel] = []
	private var filteredLocations: [LocationModel] = []
	private var currentPage = 1
	private var endReached = false
	
	let searchText = PublishSubject<String>()
	let snapshot = BehaviorRelay<LocationFeedViewController.Snapshot>(value: LocationFeedViewController.Snapshot())
	let isLoading = BehaviorRelay<Bool>(value: false)
	private var searching = false
	
	init(service: RMService, coordinator: LocationCoordinator) {
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
			.flatMap { [weak self] (query) -> Observable<[LocationModel]> in
				self?.searching = query.count > 2
				if query.count < 2 {
					return .just([])
				}
				return self?.service.filterLocations(query: query) ?? .just([])
			}
			.subscribe(onNext: { [weak self] locations in
				self?.filteredLocations = locations
				self?.createSnapshot()
			})
			.disposed(by: disposeBag)
		
		super.setupModel()
	}
	
	func requestData() {
		isLoading.accept(true)
		
		service.getLocations(by: currentPage.mapPageToIDs())
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] result in
				
				switch result {
					case .success(let models):
						self?.endReached = models.count < 20 ? false : true
						self?.allLocations.append(contentsOf: models)
					case .failure(let error):
						print(error.localizedDescription)
						self?.coordinator.showError(error: error)
				}
				self?.isLoading.accept(false)
			})
			.disposed(by: disposeBag)
	}
	
	func createSnapshot() {
		var snapshot = LocationFeedViewController.Snapshot()
		snapshot.appendSections([.locationFeed])
		
		
		let charactersToShow = searching ? filteredLocations : allLocations
		//Location Cell
//		let locationCellModels: [CharacterCellModel] = charactersToShow
//			.map { CharacterCellModel(with: $0) }
//		
//		characterCellModels.forEach { [weak self] location in
//			location.onCellTapped = {
//				let transition = PushTransition(isAnimated: true)
//				self?.coordinator.route(to: .detailLocation(id: location.id), with: transition)
//			}
//		}
//		snapshot.appendItems(characterCellModels, toSection: .locationFeed)
		
		//		Loading Cell
		if isLoading.value {
			snapshot.appendSections([.loadingCell])
			let loadingCellModel = LoadingCellModel()
			snapshot.appendItems([loadingCellModel], toSection: .loadingCell)
		}
		
		self.snapshot.accept(snapshot)
	}
	
	func loadMoreData() {
		if isLoading.value || searching || allLocations.isEmpty || !endReached { return }
		currentPage += 1
		requestData()
	}
	
	
	
}
