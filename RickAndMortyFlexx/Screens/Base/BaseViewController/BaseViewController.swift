//
//  BaseViewController.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 31.03.2021.
//

import RxSwift

class BaseViewController<ViewModel: BaseViewModel>: UIViewController {
	enum Section: Hashable {}
	
  var viewModel: ViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupStyle()
    setupRx()
  }
  
  func setupRx() { }
  func setupStyle() { }
  
  class func createWithStoryboard(_ storyboard: UIStoryboard, with viewModel: ViewModel ) -> BaseViewController? {
    guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? BaseViewController else {
      assertionFailure("Cannot instantiate UIViewController with \(identifier) from Storyboard")
      return nil
    }
    
    viewController.viewModel = viewModel
    return viewController
  }
  
  class func createFromNib(with viewModel: ViewModel) -> BaseViewController? {
    guard let viewController = UIViewController(nibName: identifier, bundle: .main) as? BaseViewController else {
      assertionFailure("Cannot instantitate UIViewController with \(identifier) from Nib")
      return nil
    }
    
    viewController.viewModel = viewModel
    return viewController
  }
}
