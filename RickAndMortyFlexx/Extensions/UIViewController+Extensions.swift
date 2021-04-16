//
//  UIViewController+Extensions.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 31.03.2021.
//

import UIKit

extension UIViewController {
  static var identifier: String {
    return String(describing: self)
  }
}


extension UIScrollView {
	func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
		self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
	}
}

extension UINavigationItem {
	func setCustomTitle(text: String) {
		let titleLabel = UILabel()
		titleLabel.attributedText = text.toStrokeText()
		titleLabel.sizeToFit()
		self.titleView = titleLabel
	}
}
