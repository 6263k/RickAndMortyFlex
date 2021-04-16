//
//  BaseCellModel.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 05.04.2021.
//

import UIKit

class BaseCellModel {
	private let id: String
	
	let cellIdentifier : String

	init(cellIdentifier: String){
		self.cellIdentifier = cellIdentifier
		self.id = UUID().uuidString
	}
	
	func cellSize(width: CGFloat = 50.0, height: CGFloat = 50.0) -> CGSize {
		return CGSize(width: width, height: height)
	}
	
	func cellHeight(height: CGFloat = 50.0) -> CGFloat {
		return height
	}
	
	func cellWidth(width: CGFloat = 50.0) -> CGFloat {
		return width
	}
  
}


extension BaseCellModel: Hashable {

	static func == (lhs: BaseCellModel, rhs: BaseCellModel) -> Bool {
		lhs.id == rhs.id
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
	}
	
}
