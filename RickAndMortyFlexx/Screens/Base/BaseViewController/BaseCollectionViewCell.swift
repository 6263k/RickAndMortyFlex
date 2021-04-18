//
//  BaseCollectionViewCell.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 05.04.2021.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell{
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with cellModel: BaseCellModel){
    }
}

extension BaseCollectionViewCell {
    static var cellIdentifier : String{
        return String(describing: self)
    }
	
	func setShadow(shadowColor: CGColor = UIColor.black.cgColor,
								 shadowOFFset: CGSize = CGSize(width: 0.0, height: 2.0),
								 shadowRadius: CGFloat = 2.0,
								 shadowOpacity: Float = 0.5) {
		
		self.layer.shadowColor = shadowColor
		self.layer.shadowOffset = shadowOFFset
		self.layer.shadowRadius = shadowRadius
		self.layer.shadowOpacity = shadowOpacity
		self.layer.masksToBounds = false
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
	}
}
