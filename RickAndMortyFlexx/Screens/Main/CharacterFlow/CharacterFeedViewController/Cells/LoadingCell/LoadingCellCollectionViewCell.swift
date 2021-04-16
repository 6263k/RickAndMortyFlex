//
//  LoadingCellCollectionViewCell.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 11.04.2021.
//

import UIKit

class LoadingCellCollectionViewCell: BaseCollectionViewCell {
	@IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	override func configure(with cellModel: BaseCellModel) {
		guard let _ = cellModel as? LoadingCellModel else { return }
		
		loadingIndicator.color = .systemPink
		loadingIndicator.startAnimating()
	}

}
