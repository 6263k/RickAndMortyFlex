//
//  APIClient.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 17.03.2021.
//

import Moya
import RxSwift
import Alamofire

final class APIManager {
  let provider: MultiMoyaProvider
  let session: Session
  
  init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
    self.session = Session(configuration: configuration)
    let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
    let plugins: [PluginType] = [] //[NetworkLoggerPlugin.init(configuration: loggerConfig)] 
    self.provider = MultiMoyaProvider(session: session, plugins: plugins)
  }
  
  func request(_ target: TargetType) -> Single<Result<Data, APIError>> {
    return provider.request(MultiTarget(target))
  }
  
}
