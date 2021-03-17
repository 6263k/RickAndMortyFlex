//
//  ViewController.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import UIKit

class ViewController: UIViewController {
  let apiClient = APIClient()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    apiClient.getAllCharacters() { result in
      switch result {
      case .success(let models):
        models.forEach { (model) in
          print(model.id)
        }
      case .failure(let error):
        print(error)
      }
    }
  }


}

