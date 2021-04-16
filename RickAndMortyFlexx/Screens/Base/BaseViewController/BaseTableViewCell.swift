//
//  BaseTableViewCell.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 09.04.2021.
//

import UIKit


class BaseTableViewCell: UITableViewCell {
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	func configure(with cellModel: BaseCellModel){
	}
}

extension BaseTableViewCell {
	static var cellIdentifier : String{
		return String(describing: self)
	}
}
