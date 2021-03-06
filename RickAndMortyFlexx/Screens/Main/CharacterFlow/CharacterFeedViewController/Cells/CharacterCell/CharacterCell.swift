//
//  CharacterCell.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 05.04.2021.
//

import UIKit
import RxSwift
import Kingfisher

class CharacterCell: BaseCollectionViewCell {
  @IBOutlet private weak var characterImage: UIImageView!
  @IBOutlet private weak var characterName: UILabel!
	@IBOutlet private weak var opacityView: UIView!
	
	private weak var cellModel: CharacterCellModel?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  override func configure(with cellModel: BaseCellModel) {
    super.configure(with: cellModel)
    guard let characterCellModel = cellModel as? CharacterCellModel else { return }
		self.cellModel = characterCellModel
		
		let imageURL = URL(string: characterCellModel.characterImage)
		characterImage.kf.indicatorType = .activity
		characterImage.kf.setImage(with: imageURL)
		
	
		characterImage.contentMode = .scaleToFill
		characterImage.layer.shadowColor = UIColor.black.cgColor
		characterImage.layer.shadowOpacity = 1
		characterImage.layer.shadowOffset = .zero
		
		opacityView.backgroundColor = UIColor(white: 1.0, alpha: 0.3)
		
		let strokeColor: UIColor = .rmGreen
		let foregroundColor: UIColor = .rmDarkBlue
		characterName.attributedText = characterCellModel.characterName.toStrokeText(strokeWidth: -1.0,
																																								 strokeColor: strokeColor,
																																								 foregroundColor: foregroundColor,
																																								 font: UIFont.boldSystemFont(ofSize: 19.0))
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onCellTapped))
		tapGesture.numberOfTapsRequired = 1

		self.contentView.addGestureRecognizer(tapGesture)
		
		self.contentView.layer.cornerRadius = 16
		self.contentView.layer.masksToBounds = true
		
		setShadow()
		
		prepareForReuse()
		super.prepareForReuse()
  }
  
	@objc func onCellTapped() {
		cellModel?.onCellTapped?()
	}
  

}
