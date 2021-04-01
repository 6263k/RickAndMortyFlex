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


extension UINavigationController {
  public func showAsync(_ vc: UIViewController, sender: Any?) {
    DispatchQueue.main.async {
      self.show(vc, sender: sender)
    }
  }
}
