//
//  EpisodeReusableHeader.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 15.04.2021.
//

import UIKit

class EpisodeReusableHeader: BaseReusableView {
	static let kind: String = "HeaderSection"
	
	@IBOutlet private weak var headerLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
	func configure(with text: String) {
		headerLabel.attributedText = text.toStrokeText(strokeWidth: 0, strokeColor: .rmPurple, foregroundColor: .rmPurple, font: .boldSystemFont(ofSize: 35))
	}
}
