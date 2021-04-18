//
//  EpisodeDetailCellModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 18.04.2021.
//

import Foundation


final class EpisodeDetailCellModel: BaseCellModel {
	
	let episodeName: String
	let episodeCode: String
	let episodeDate: String
	
	init(with cellModel: EpisodeModel) {
		episodeName = cellModel.name
		episodeCode = cellModel.episode
		episodeDate = cellModel.airDate
		
		super.init(cellIdentifier: EpisodeDetailCell.cellIdentifier)
	}
}
