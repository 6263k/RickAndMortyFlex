//
//  ErrorView.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 07.04.2021.
//

import UIKit

class ErrorView: UIView {
	
	@IBOutlet private weak var textLabel: UILabel!
	@IBOutlet private weak var closeButton: UIButton!
	
	private static var sharedView: ErrorView!
	
	static func loadFromNib() -> ErrorView {
		let nibName = "\(self)".split{$0 == "."}.map(String.init).last!
		let nib = UINib(nibName: nibName, bundle: nil)
		return nib.instantiate(withOwner: self, options: nil).first as! ErrorView
	}
	
	static func showIn(viewController: UIViewController, message: String) {
		var offset: CGFloat = 0
		var displayVC = viewController
		
		if let tabController = viewController as? UITabBarController {
			displayVC = tabController.selectedViewController ?? viewController
		}
		
		if let navController = viewController as? UINavigationController {
			offset = navController.tabBarController?.tabBar.frame.size.height ?? 0
		}
		
		if sharedView == nil {
			sharedView = loadFromNib()
			
			sharedView.layer.masksToBounds = false
			sharedView.layer.shadowColor = UIColor.darkGray.cgColor
			sharedView.layer.shadowOpacity = 1
			sharedView.layer.shadowOffset = CGSize(width: 0, height: 3)
		}
		
		sharedView.textLabel.text = message
		
		if sharedView?.superview == nil {
			let y = displayVC.view.frame.height - sharedView.frame.size.height - 12 - offset
			sharedView.frame = CGRect(x: 12, y: y, width: displayVC.view.frame.size.width - 24, height: sharedView.frame.size.height)
			sharedView.alpha = 0.0
			
			displayVC.view.addSubview(sharedView)
			sharedView.fadeIn()
			
			// this call needs to be counter balanced on fadeOut [1]
			sharedView.perform(#selector(fadeOut), with: nil, afterDelay: 3.0)
		}
	}
	
	@IBAction func closePressed(_ sender: UIButton) {
		fadeOut()
	}
	
	func fadeIn() {
		UIView.animate(withDuration: 0.33, animations: {
			self.alpha = 1.0
		})
	}
	
	@objc func fadeOut() {
		
		// [1] Counter balance previous perfom:with:afterDelay
		NSObject.cancelPreviousPerformRequests(withTarget: self)
		
		UIView.animate(withDuration: 0.33, animations: {
			self.alpha = 0.0
		}, completion: { _ in
			self.removeFromSuperview()
		})
	}
}
