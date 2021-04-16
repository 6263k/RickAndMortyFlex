//
//  DetailCharacterCellModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 10.04.2021.
//

import UIKit

class CharacterDetailCellModel: BaseCellModel {
	
	let characterId: Int
	let characterName: String
	let characterImage: String
	let characterStatus: CharacterModel.CharacterStatus
	let characterGender: CharacterModel.CharacterGender
	let characterSpecies: String
	let characterType: String
	let characterLocation: LocationModel
	let characterOrigin: LocationModel
	
	init(with character: CharacterModel) {
		self.characterId = character.id
		self.characterName = character.name
		self.characterImage = character.image
		self.characterStatus = character.status
		self.characterGender = character.gender
		self.characterSpecies = character.species
		self.characterType = character.type.isEmpty ? "No Type" : character.type
		self.characterLocation = character.location!
		

	
		self.characterOrigin = character.origin!
		super.init(cellIdentifier: CharacterDetailCell.cellIdentifier)
	}
}

