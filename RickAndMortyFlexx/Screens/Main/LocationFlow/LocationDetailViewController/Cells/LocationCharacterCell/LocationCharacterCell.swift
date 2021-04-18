//
//  LocationCharacterCell.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 17.04.2021.
//

import UIKit
import Kingfisher

class LocationCharacterCell: BaseCollectionViewCell {

	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var pictureView: UIImageView!
	@IBOutlet private weak var genderLabel: UILabel!
	@IBOutlet private weak var speciesOpacityView: UIView!
	@IBOutlet private weak var speciesLabel: UILabel!
	
	private var imageURL: URL!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		pictureView.kf.setImage(with: imageURL, placeholder: UIImage(named: "AssetRMDrip"))
		pictureView.layer.borderWidth = 1
		pictureView.layer.masksToBounds = false
		pictureView.layer.borderColor = UIColor.rmCyan.cgColor
		pictureView.layer.cornerRadius = contentView.frame.width * 0.4 / 2
		pictureView.clipsToBounds = true
		
		pictureView.contentMode = .scaleAspectFit
		
	}
	
	override func configure(with cellModel: BaseCellModel) {
		super.configure(with: cellModel)
		guard let locationCharacterCellModel = cellModel as? LocationCharacterCellModel else { return }
		
		nameLabel.text = locationCharacterCellModel.characterName
		
		
	
		genderLabel.text = locationCharacterCellModel.characterGender
		
		speciesLabel.text = locationCharacterCellModel.characterSpecies
		
		speciesOpacityView.layer.cornerRadius = 16
		speciesOpacityView.layer.masksToBounds = true
		speciesOpacityView.backgroundColor = UIColor.orange.withAlphaComponent(1)
		
		imageURL = URL(string: locationCharacterCellModel.characterImageURL)
		
		self.contentView.layer.cornerRadius = 30
		self.contentView.layer.masksToBounds = true
	
		self.contentView.backgroundColor = .rmBrown
		
		setShadow()
		layoutSubviews()
		super.prepareForReuse()
	}
}
