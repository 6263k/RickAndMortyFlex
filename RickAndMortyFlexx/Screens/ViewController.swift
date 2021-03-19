//
//  ViewController.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import UIKit

class ViewController: UIViewController {
  let apiSerivce = APIService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    apiSerivce.getAllCharacters { (result) in
      switch result {
      case .success(let characters):
        characters.forEach { print($0.id) }
        print("done")
      case .failure(let error):
        print(error)
      }
      
    }
  }

}

