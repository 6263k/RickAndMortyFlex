//
//  EpisodeDetailCell.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 18.04.2021.
//

import UIKit

class EpisodeDetailCell: BaseCollectionViewCell {
 
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var codeLabel: UILabel!
	@IBOutlet private weak var codeOpacityView: UIView!
	@IBOutlet private weak var dateLabel: UILabel!
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}

	
	override func configure(with cellModel: BaseCellModel) {
		super.configure(with: cellModel)
		guard let episodeDetailCellModel = cellModel as? EpisodeDetailCellModel else { return }
		
		nameLabel.text = episodeDetailCellModel.episodeName
		
		codeLabel.text = episodeDetailCellModel.episodeCode
		codeOpacityView.backgroundColor = .orange
		codeOpacityView.layer.cornerRadius = 25
		
		dateLabel.text = episodeDetailCellModel.episodeDate
		
		
		contentView.backgroundColor = .rmLeafGrean
		contentView.layer.cornerRadius = 40
		setShadow()
	}
}
