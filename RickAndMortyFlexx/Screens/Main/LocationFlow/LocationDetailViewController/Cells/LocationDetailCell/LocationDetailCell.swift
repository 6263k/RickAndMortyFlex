//
//  LocationDetailCell.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.04.2021.
//

import UIKit

class LocationDetailCell: BaseCollectionViewCell {
	
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var typeOpacityView: UIView!
	@IBOutlet private weak var typeLabel: UILabel!
	@IBOutlet private weak var dimensionOpacityView: UIView!
	@IBOutlet private weak var dimensionLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func configure(with cellModel: BaseCellModel) {
		super.configure(with: cellModel)
		guard let locationDetailCellModel = cellModel as? LocationDetailCellModel else { return }
		
		nameLabel.text = locationDetailCellModel.locationName
		
		typeOpacityView.backgroundColor = UIColor.orange
		typeOpacityView.layer.cornerRadius = 20
		typeLabel.text = locationDetailCellModel.locationType
		
		dimensionOpacityView.backgroundColor = UIColor.rmGreen
		dimensionOpacityView.layer.cornerRadius = 20
		dimensionLabel.text = locationDetailCellModel.locationDimension
		
		self.contentView.backgroundColor = UIColor.rmLightYellow
		self.contentView.layer.cornerRadius = 35
		self.contentView.layer.masksToBounds = true
		
		
		setShadow()

	}

}
