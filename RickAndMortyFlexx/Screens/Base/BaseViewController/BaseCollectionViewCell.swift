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
}
