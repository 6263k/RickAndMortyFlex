//
//  ViewController.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//

import UIKit
import RxSwift
import RealmSwift

class ViewController: UIViewController {
  let apiManager = APIManager()
  let disposeBag = DisposeBag()
  let dbmanager = DBManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    apiManager.request(CharacterTarget.character(page: 1 ))
      .mapDecodable(from: CharacterInfoModel.self)
      .subscribe(onSuccess: { [weak self] result in
        switch result {
        case .success(let info):
          self?.dbmanager?.saveCharacters(characters: info.results)
          self?.dbmanager?.getObjects(ofType: CharacterModel.self).subscribe(onNext: { models in
            models.forEach { print($0.id)}
          })
        case .failure(let error):
          print(error.localizedDescription)
        }
      })
      .disposed(by: disposeBag)
      
  }

}

