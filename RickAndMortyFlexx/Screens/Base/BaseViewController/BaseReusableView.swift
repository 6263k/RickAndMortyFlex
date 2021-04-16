//
//  BaseReusableView.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 15.04.2021.
//

import UIKit

class BaseReusableView: UICollectionReusableView {
	
	static var reuseIdentifier: String {
		String(describing: self)
	}
	
	func configure() {
		
	}
	
}
