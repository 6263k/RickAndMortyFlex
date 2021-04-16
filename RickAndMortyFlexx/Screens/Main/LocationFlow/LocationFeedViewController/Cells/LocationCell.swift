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
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	override func configure(with cellModel: BaseCellModel) {
		super.configure(with: cellModel)
		guard let locationCellModel = cellModel as? LocationCellModel else { return }
		
		
	}
	
	
}
