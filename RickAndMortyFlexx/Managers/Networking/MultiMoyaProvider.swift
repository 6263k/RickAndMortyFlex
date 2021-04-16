//
//  ApiManager.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 16.03.2021.
//
import Moya
import RxSwift
import Alamofire

class MultiMoyaProvider: MoyaProvider<MultiTarget> {
  typealias Target = MultiTarget
  let disposeBag = DisposeBag()
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
    var error: APIError?
    NetworkReachabilityManager.rx.reachable.subscribe(onNext: { status in
      if !status {
        error = .networkNotAvailable
      }
    }).disposed(by: disposeBag)
    
    return Single.create { [weak self] observer in
      if let error = error {
        observer(.success(.failure(error)))
        return Disposables.create()
      }
      
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
