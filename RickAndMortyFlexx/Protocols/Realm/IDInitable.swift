//
//  IDInitable.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 27.03.2021.
//

import RealmSwift

protocol IDInitable where Self: Object {
  init(id: Int)
}
