//
//  Realm+Write.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 26.03.2021.
//

import RealmSwift


extension Realm {
  func safeWrite(_ block: () -> Void) {
    do {
      if !isInWriteTransaction {
        try write(block)
      }
    } catch let error as NSError {
      print("Couldn't write to a database becase of \(error.localizedDescription)")
    }
  }
  
  func checkObjectExists<Element: Object>(objectType: Element.Type, id: Int) -> Bool {
    let result = self.object(ofType: objectType, forPrimaryKey: id) != nil
    return result
  }
}
