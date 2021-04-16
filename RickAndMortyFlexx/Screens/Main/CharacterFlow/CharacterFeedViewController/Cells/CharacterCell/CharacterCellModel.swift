//
//  CharacterCellModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 05.04.2021.
//

import RxSwift

class CharacterCellModel: BaseCellModel {
  
	let id: Int
	let characterName: String
	let characterImage: String
	var onCellTapped: VoidBlock?
	
  init(with character: CharacterModel) {
		self.id = character.id
		self.characterName = character.name
		self.characterImage = character.image
		
		super.init(cellIdentifier: CharacterCell.cellIdentifier)
  }
	
  
}
