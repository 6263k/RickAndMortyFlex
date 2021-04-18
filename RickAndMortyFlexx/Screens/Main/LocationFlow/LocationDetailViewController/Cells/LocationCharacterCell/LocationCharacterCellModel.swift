//
//  LocationCharacterCellModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 17.04.2021.
//

import Foundation

final class LocationCharacterCellModel: BaseCellModel {
	
	let id: Int
	let characterName: String
	let characterImageURL: String
	let characterSpecies: String
	let characterGender: String
	
	var onCellTapped: VoidBlock?
	
	init(with characterModel: CharacterModel) {
		id = characterModel.id
		characterName = characterModel.name
		characterImageURL = characterModel.image
		characterSpecies = characterModel.species == "unknown" ? "Unknown🤔" : characterModel.species
		characterGender = characterModel.gender.rawValue == "unknown" ? "Unknown🤔" : characterModel.gender.rawValue
		super.init(cellIdentifier: LocationCharacterCell.cellIdentifier)
	}
}
