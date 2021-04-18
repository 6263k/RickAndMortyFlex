//
//  LocationDetailViewModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.04.2021.
//

import RxSwift
import RxCocoa

final class LocationDetailViewModel: BaseViewModel {
	private let disposeBag = DisposeBag()
	private let id: Int
	private let service: RMService
	
	private var location: LocationModel!
	
	var coordinator: LocationCoordinator
	let snapshot = BehaviorRelay<LocationDetailViewController.Snapshot>(value: LocationDetailViewController.Snapshot())
	let isLoading = BehaviorRelay<Bool>(value: false)
	
	init(service: RMService, id: Int, coordinator: LocationCoordinator) {
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
		
		service.requestLocationWithItsData(by: id)
			.subscribe(onNext: {[weak self] result in
				switch result {
					case .success(let location):
						self?.location = location
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
		var snapshot = LocationDetailViewController.Snapshot()
		snapshot.appendSections([.locationHeader, .charactersInLocation])
		
		let locationDetailCellModel = LocationDetailCellModel(with: location)
		snapshot.appendItems([locationDetailCellModel], toSection: .locationHeader)
		
		let characterCellModels = location.characters.toArray()
			.map {LocationCharacterCellModel(with: $0)}

		snapshot.appendItems(characterCellModels, toSection: .charactersInLocation)
		
		self.snapshot.accept(snapshot)
	}
	
}

