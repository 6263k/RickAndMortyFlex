//
//  LocationCell.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 15.04.2021.
//

import UIKit

class EpisodeCharacterCell: BaseCollectionViewCell {

	@IBOutlet private weak var dateLabel: UILabel!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var episodeNumber: UILabel!
	@IBOutlet private weak var opacityView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	override func configure(with cellModel: BaseCellModel) {
		super.configure(with: cellModel)
		guard let episodeModel = cellModel as? EpisodeCharacterCellModel else { return }
		
	
		dateLabel.text = episodeModel.episodeDate
		
		nameLabel.text = episodeModel.episodeName
		
		episodeNumber.text = episodeModel.episodeNumber
		opacityView.backgroundColor = .orange
		opacityView.backgroundColor?.withAlphaComponent(0.5)
		opacityView.layer.cornerRadius = 10
		
		let colors: [UIColor] = [.rmBrown, .rmLightYellow, .rmLeafGrean]
		self.backgroundColor = colors[Int.random(in: 0..<colors.count)]
		
		self.layer.cornerRadius = 10
	}
}
