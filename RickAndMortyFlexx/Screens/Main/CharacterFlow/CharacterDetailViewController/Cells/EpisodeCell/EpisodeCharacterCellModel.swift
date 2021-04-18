//
//  LocationCharacterCellModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 15.04.2021.
//

import Foundation


final class EpisodeCharacterCellModel: BaseCellModel {
	private var episode: EpisodeModel!
	
	let id: Int
	let episodeName: String
	let episodeDate: String
	let episodeNumber: String
	var onCellTapped: VoidBlock?
	
	init(with episodeModel: EpisodeModel) {
		
		self.episode = episodeModel
		
		id = episodeModel.id
		episodeDate = episodeModel.airDate
		episodeName = episodeModel.name
		episodeNumber = episodeModel.episode
		
		
		super.init(cellIdentifier: EpisodeCharacterCell.cellIdentifier)
	}
}
