//
//  String+ID.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 27.03.2021.
//

import UIKit


extension String {
  @inlinable func stringToURLIDcompnent() -> Int? {
    if let url = URL(string: self) {
      return Int(url.lastPathComponent)
    }
    return nil
  }
	
	func toStrokeText(strokeWidth: CGFloat = -2.0,
										strokeColor: UIColor = .rmGreen,
										foregroundColor: UIColor = .rmCyan,
										font: UIFont = UIFont.rmFont(ofSize: 30.0)) -> NSAttributedString {
		
		let attributedText = [NSAttributedString.Key.strokeWidth: strokeWidth,
													NSAttributedString.Key.strokeColor: strokeColor,
													NSAttributedString.Key.foregroundColor: foregroundColor,
													NSAttributedString.Key.font: font] as
			[NSAttributedString.Key: Any]
		return NSAttributedString(string: self, attributes: attributedText)
		
	}
}

