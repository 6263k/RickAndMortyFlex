//
//  LocationCellModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.04.2021.
//

import Foundation


final class LocationCellModel: BaseCellModel {
	
	let id: Int
	let locationName: String
	let locationDimension: String
	let locationType: String
	var onCellTapped: VoidBlock?
	
	init(with locationModel: LocationModel) {
		self.id = locationModel.id
		self.locationName = locationModel.name
		self.locationDimension = locationModel.dimension == "unknown" ? "Unknown ¯\\_(ツ)_/¯" : locationModel.dimension
		self.locationType = locationModel.type
		
		super.init(cellIdentifier: LocationCell.cellIdentifier)
	}
}
