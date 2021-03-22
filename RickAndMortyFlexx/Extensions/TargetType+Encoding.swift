//
//  TargetType+Encoding.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 20.03.2021.
//

import Moya

extension TargetType {
  var defaultParameterEncoding: ParameterEncoding {
    URLEncoding.default
  }
}
