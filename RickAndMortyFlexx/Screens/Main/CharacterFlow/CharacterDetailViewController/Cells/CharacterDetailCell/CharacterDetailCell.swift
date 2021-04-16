//
//  CharacterDetailCell.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 10.04.2021.
//

import UIKit
import Kingfisher

class CharacterDetailCell: BaseCollectionViewCell {

	
	@IBOutlet private weak var pictureView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var opacityView: UIView!
	@IBOutlet weak var statusLabel: UILabel!
	@IBOutlet weak var genderLabel: UILabel!
	@IBOutlet weak var speciesLabel: UILabel!
	@IBOutlet weak var typeLabel: UILabel!
	@IBOutlet weak var originLabel: UILabel!
	@IBOutlet weak var locationLabel: UILabel!
	
	override func configure(with cellModel: BaseCellModel) {
		super.configure(with: cellModel)
		guard let characterDetailModel = cellModel as? CharacterDetailCellModel else { fatalError() }
		
		let imageURL = URL(string: characterDetailModel.characterImage)
		pictureView.kf.indicatorType = .activity
		pictureView.kf.setImage(with: imageURL)
		pictureView.contentMode = .scaleToFill
		
		var strokeColor = UIColor.rmDarkGreen
		var foregroundColor = UIColor.rmPurple
		opacityView.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
		if let isLight = pictureView.image?.averageColor?.isLight(),
			 !isLight {
			strokeColor = .rmCyan
			foregroundColor = .rmGreen
			opacityView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
		}
		
		
		nameLabel.attributedText = characterDetailModel.characterName.toStrokeText(strokeWidth: -3.0, strokeColor: strokeColor, foregroundColor: foregroundColor, font: UIFont.boldSystemFont(ofSize: 35.0))

		
		statusLabel.text = characterDetailModel.characterStatus.rawValue
		genderLabel.text = characterDetailModel.characterGender.rawValue
		speciesLabel.text = characterDetailModel.characterSpecies
		typeLabel.text = characterDetailModel.characterType
		originLabel.text = characterDetailModel.characterOrigin.name
		locationLabel.text = characterDetailModel.characterLocation.name
		
	}
	
}
