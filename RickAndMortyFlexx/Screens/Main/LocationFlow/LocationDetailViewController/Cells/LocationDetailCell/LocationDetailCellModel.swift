//
//  LocationDetailCellModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.04.2021.
//

final class LocationDetailCellModel: BaseCellModel {
	private var location: LocationModel!
	
	let locationName: String
	let locationDimension: String
	let locationType: String
	
	init(with locationModel: LocationModel) {
		self.location = locationModel
		
		self.locationName = locationModel.name
		self.locationDimension = locationModel.dimension == "unknown" ? "Unknown ¯\\_(ツ)_/¯" : locationModel.dimension
		self.locationType = locationModel.type
		
		super.init(cellIdentifier: LocationDetailCell.cellIdentifier)
	}
}

