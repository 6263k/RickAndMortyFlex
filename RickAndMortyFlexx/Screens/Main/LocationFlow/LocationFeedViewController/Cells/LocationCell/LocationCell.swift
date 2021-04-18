//
//  LocationCell.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.04.2021.
//

import UIKit

class LocationCell: BaseCollectionViewCell {

	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var typeOpacityView: UIView!
	@IBOutlet private weak var typeLabel: UILabel!
	@IBOutlet private weak var dimensionOpacityView: UIView!
	@IBOutlet private weak var dimensionLabel: UILabel!
	
	private weak var cellModel: LocationCellModel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	override func configure(with cellModel: BaseCellModel) {
		super.configure(with: cellModel)
		guard let locationCellModel = cellModel as? LocationCellModel else { return }
		self.cellModel = locationCellModel
		
		nameLabel.text = locationCellModel.locationName
		
		typeOpacityView.backgroundColor = UIColor.orange
		typeOpacityView.layer.cornerRadius = 10
		typeLabel.text = locationCellModel.locationType
		
		dimensionLabel.text = locationCellModel.locationDimension
		
		dimensionOpacityView.backgroundColor = UIColor.rmGreen
		dimensionOpacityView.layer.cornerRadius = 10
		
		
		let colors = UIColor.rmRandomColors
		self.contentView.backgroundColor = .rmLightYellow //colors[Int.random(in: 0..<colors.count)]
		
		
		self.contentView.layer.cornerRadius = 25
		self.contentView.layer.masksToBounds = true
		
		setShadow()
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCellTapped))
		tapGesture.numberOfTapsRequired = 1
		self.contentView.addGestureRecognizer(tapGesture)
	}
	
	@objc private func onCellTapped() {
		cellModel?.onCellTapped?()
	}
}
