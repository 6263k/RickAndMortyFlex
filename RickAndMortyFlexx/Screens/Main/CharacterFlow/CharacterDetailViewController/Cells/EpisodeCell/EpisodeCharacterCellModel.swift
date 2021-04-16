//
//  LocationCharacterCellModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 15.04.2021.
//

import Foundation


final class EpisodeCharacterCellModel: BaseCellModel {
	private var episode: EpisodeModel!
	
	let episodeName: String
	let episodeDate: String
	let episodeNumber: String
	
	init(with episodeModel: EpisodeModel) {
		
		self.episode = episodeModel
		
		self.episodeDate = episodeModel.airDate
		self.episodeName = episodeModel.name
		self.episodeNumber = episodeModel.episode
		
		
		super.init(cellIdentifier: EpisodeCharacterCell.cellIdentifier)
	}
}
