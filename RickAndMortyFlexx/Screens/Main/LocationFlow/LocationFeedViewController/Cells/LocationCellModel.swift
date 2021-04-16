//
//  LocationCellModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.04.2021.
//

import Foundation


final class LocationCellModel: BaseCellModel {
	private var location: LocationModel!
	
	let locationName: String
	let locationDimension: String
	let locationType: String
	
	init(with locationModel: LocationModel) {
		self.location = locationModel
		
		self.locationName = locationModel.name
		self.locationDimension = locationModel.dimension
		self.locationType = locationModel.type
		
		super.init(cellIdentifier: EpisodeCharacterCell.cellIdentifier)
	}
}
