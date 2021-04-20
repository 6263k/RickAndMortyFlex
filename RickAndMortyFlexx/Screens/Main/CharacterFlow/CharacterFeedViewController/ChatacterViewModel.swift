//
//  ChatacterViewModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 31.03.2021.
//

import RxSwift
import RxCocoa

typealias VoidBlock = () -> Void

final class CharacterFeedViewModel: BaseViewModel {
  private let disposeBag = DisposeBag()
  private let service: RMService

	var coordinator: CharacterCoordinator
	
	private var allCharacters: [CharacterModel] = []
	private var filteredChracters: [CharacterModel] = []
	private var currentPage = 1
	private var endReached = false
	
	let searchText = PublishSubject<String>()
	let snapshot = BehaviorRelay<CharacterFeedViewController.Snapshot>(value: CharacterFeedViewController.Snapshot())
	let isLoading = BehaviorRelay<Bool>(value: false)
	private var searching = false
	
	init(service: RMService, coordinator: CharacterCoordinator) {
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
			.flatMap { [weak self] (query) -> Observable<[CharacterModel]> in
				self?.searching = query.count > 2
				if query.count < 2 {
					return .just([])
				}
				return self?.service.filterCharacters(query: query) ?? .just([])
			}
			.subscribe(onNext: { [weak self] characters in
				self?.filteredChracters = characters
				self?.createSnapshot()
			})
			.disposed(by: disposeBag)
		
		super.setupModel()
  }
	
	func requestData() {
		isLoading.accept(true)
		
		service.getCharacters(by: currentPage.mapPageToIDs())
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] result in
				
				switch result {
					case .success(let models):
						self?.endReached = models.count < 20 ? false : true
						self?.allCharacters.append(contentsOf: models)
					case .failure(let error):
						print(error.localizedDescription)
						self?.coordinator.showError(error: error)
				}
				self?.isLoading.accept(false)
			})
			.disposed(by: disposeBag)
	}
	
	func createSnapshot() {
		var snapshot = CharacterFeedViewController.Snapshot()
		snapshot.appendSections([.characterFeed])
		
		
		let charactersToShow = searching ? filteredChracters : allCharacters
		//Character Cell
		
		for character in charactersToShow {
			let characterCellModel = CharacterCellModel(with: character)
			
			characterCellModel.onCellTapped = { [weak self] in
				let transition = PushTransition(isAnimated: true)
				self?.coordinator.route(to: .detailCharacter(id: character.id), with: transition)
			}
			snapshot.appendItems([characterCellModel], toSection: .characterFeed)
		}
			
		
//		Loading Cell
		if isLoading.value {
			snapshot.appendSections([.loadingCell])
			let loadingCellModel = LoadingCellModel()
			snapshot.appendItems([loadingCellModel], toSection: .loadingCell)
		}

		self.snapshot.accept(snapshot)
	}
	
	func loadMoreData() {
		if isLoading.value || searching || allCharacters.isEmpty || !endReached { return }
		currentPage += 1
		requestData()
	}
	
	
	
}
