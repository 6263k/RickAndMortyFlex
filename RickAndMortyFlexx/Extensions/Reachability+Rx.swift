//
//  Reachability+Rx.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 05.04.2021.
//

import Alamofire
import RxSwift

extension NetworkReachabilityManager: ReactiveCompatible {}

extension Reactive where Base: NetworkReachabilityManager {
  static var reachable: Observable<Bool>  {
    return Observable.create { observable in
      let reachability: NetworkReachabilityManager? = NetworkReachabilityManager()
      if let reachability  = reachability {
        observable.onNext(reachability.isReachable)
        reachability.startListening { (status) in
          switch status {
          case .reachable:
            observable.onNext(true)
          default:
            observable.onNext(false)
          }
        }
      } else {
        observable.onNext(false)
      }
      return Disposables.create {
        reachability?.stopListening()
      }
    }
  }
}
