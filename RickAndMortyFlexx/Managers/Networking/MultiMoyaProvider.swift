//
//  ApiManager.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//
import Moya
import RxSwift


class MultiMoyaProvider: MoyaProvider<MultiTarget> {
  typealias Target = MultiTarget
  
  override init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
                requestClosure: @escaping RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
                stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
                callbackQueue: DispatchQueue? = .main,
                session: Session = MoyaProvider<Target>.defaultAlamofireSession(),
                plugins: [PluginType] = [],
                trackInflights: Bool = false) {
    
    super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue, session: session, plugins: plugins, trackInflights: trackInflights)
  }
}

extension MultiMoyaProvider {
  func request(_ target: Target) -> Single<Result<Data, APIError>> {
    return Single.create { [weak self] observer in
      let task = self?.request(target, progress: nil) { result in
        switch result {
        case .success(let response):
          observer(.success(.success(response.data)))
        case .failure:
          observer(.success(.failure(.requestFailed)))
        }
      }
      
      return Disposables.create {
        task?.cancel()
      }
    }
    
  }
}
