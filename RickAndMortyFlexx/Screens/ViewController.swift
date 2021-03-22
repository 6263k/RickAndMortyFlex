//
//  ViewController.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import UIKit
import RxSwift


class ViewController: UIViewController {
  let apiManager = APIManager()
  let disposeBag = DisposeBag()
  override func viewDidLoad() {
    super.viewDidLoad()
    apiManager.request(CharacterTarget.character(page: 1 ))
      .mapDecodable(from: CharacterInfoModel.self)
      .subscribe(onSuccess: { result in
        switch result {
        case .success(let info):
          info.results.forEach { print($0.id) }
        case .failure(let error):
          print(error.localizedDescription)
        }
      })
      .disposed(by: disposeBag)
      
  }

}

