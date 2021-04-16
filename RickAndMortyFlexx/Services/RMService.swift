//
//  RMService.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 28.03.2021.
//

import RxSwift
import Moya
import RealmSwift

final class RMService{
  private let apiManager: APIManager
  private let dbManager: DBManager
  
  private let disposeBag = DisposeBag()
  
  init(apiManager: APIManager, dbManager: DBManager) {
    self.apiManager = apiManager
    self.dbManager = dbManager
  }
  
	//MARK: -ToFix
	// Couldnt figure out how to combine this  alsmot the same functions into one using generics, since if you look into the body of function in some places i use array of models type and in some places just model itself, so the problem probably is in dbManager
	
	
	func getCharacters(by IDs: [Int]) -> Observable<Result<[CharacterModel], APIError>> {
    return Observable.create { [weak self] observable in
			let apiRequestObservable = self?.apiManager.request(CharacterTarget.charactersWith(ids: IDs)).asObservable()
			
			let apiObservable = apiRequestObservable?
				.mapDecodable(from: [CharacterModel].self)
				.share(replay: 1)
			
			let apiUntil = apiRequestObservable?
				.toSuccesOrEmpty(from: [CharacterModel].self)
				.do(onNext: { self?.dbManager.saveCharacters(characters: $0)} )
			
			let dbObservable = self?.dbManager.getObjectsWithIDs(ofType: CharacterModel.self, IDs: IDs)
				.take(until: apiUntil ?? .empty())
				.filter{ !$0.isEmpty }
        .subscribe(onNext: { result in
					observable.onNext(.success(Array(result)))
        })
      
			let apiResult = apiObservable?
				.bind(to: observable)
				
    
      return Disposables.create {
				dbObservable?.dispose()
				apiResult?.dispose()
      }
    }
  }
	
	func getEpisodes(by IDs: [Int]) -> Observable<Result<[EpisodeModel], APIError>> {
		return Observable.create { [weak self] observable in
			let apiRequestObservable = self?.apiManager.request(EpisodeTarget.episodesWith(ids: IDs)).asObservable()
			
			let apiObservable = apiRequestObservable?
				.mapDecodable(from: [EpisodeModel].self)
				.share()
			
			let apiUntil = apiRequestObservable?
				.toSuccesOrEmpty(from: [EpisodeModel].self)
				.do(onNext: { self?.dbManager.saveEpisodes(episodes: $0)})
			
			let dbObservable = self?.dbManager.getObjectsWithIDs(ofType: EpisodeModel.self, IDs: IDs)
				.take(until: apiUntil ?? .empty())
				.subscribe(onNext: { result in
					observable.onNext(.success(Array(result)))
				})
			
			let apiResult = apiObservable?
				.bind(to: observable)
			
			return Disposables.create {
				dbObservable?.dispose()
				apiResult?.dispose()
			}
		}
	}
	
	func getLocations(by IDs: [Int]) -> Observable<Result<[LocationModel], APIError>> {
		return Observable.create { [weak self] observable in
			let apiRequestObservable = self?.apiManager.request(LocationTarget.locationsWith(ids: IDs)).asObservable()
			
			let apiObservable = apiRequestObservable?
				.mapDecodable(from: [LocationModel].self)
				.share()
			
			let apiUntil = apiRequestObservable?
				.toSuccesOrEmpty(from: [LocationModel].self)
				.do(onNext: { self?.dbManager.saveLocations(locations: $0) })
			
			let dbObservable = self?.dbManager.getObjectsWithIDs(ofType: LocationModel.self, IDs: IDs)
				.take(until: apiUntil ?? .empty())
				.subscribe(onNext: { result in
					observable.onNext(.success(Array(result)))
				})
			
			let apiResult = apiObservable?
				.bind(to: observable)
			
			return Disposables.create {
				dbObservable?.dispose()
				apiResult?.dispose()
			}
		}
	}
	
	
	func requestCharacterWithHisData(by characterId: Int) -> Observable<Result<CharacterModel, APIError>> {
		return Observable.create { [unowned self] observable in
			
			let characterDB = self.dbManager.getObjectWithID(ofType: CharacterModel.self, ID: characterId)
				.compactMap { $0.first }
				.share(replay: 1)
			let characterObs = characterDB.subscribe(onNext: { observable.onNext(.success($0))})
			
			
			let characterRequest = self.apiManager.request(CharacterTarget.charaterWith(id: characterId)).asObservable()
				.mapDecodable(from: CharacterModel.self)
			
			let locationRequest = characterDB.map { character -> [Int] in
				guard let id = character.location?.id, id != Int.max else { return []}
				return [id]
			}.flatMap { ids -> Single<Result<Data, APIError>> in
				if ids.isEmpty { return .never() }
				return self.apiManager.request(LocationTarget.locationsWith(ids: ids))
			}.asObservable()
			.mapDecodable(from: LocationModel.self)
			
			let originRequest = characterDB.map { character -> [Int] in
				guard let id = character.origin?.id, id != Int.max else { return []}
				return [id]
			}.flatMap { ids -> Single<Result<Data, APIError>> in
				if ids.isEmpty { return .never() }
				return self.apiManager.request(LocationTarget.locationsWith(ids: ids))
			}.asObservable()
			.mapDecodable(from: LocationModel.self)
			
			//API GIVES ME DIFFERENT RESPONSES WHEN IM REQUESTING SINGLE EPISODE OR MULTIPLE EPISODES THAT'S WHY I NEED THIS WEIRD CODE
			let singleEpisodeRequest = characterDB.map { character -> [Int] in
				return character.episode.map { $0.id }
			}
			.flatMap { ids -> Single<Result<Data, APIError>> in
				if ids.count == 1 { return self.apiManager.request(EpisodeTarget.episodesWith(ids: ids)) }
				return .never()
			}
			.mapDecodable(from: EpisodeModel.self)
			.map { result in
				result.map {[$0]}
			}
			
			let multipleEpisodeRequest = characterDB.map { character -> [Int] in
				return character.episode.map { $0.id }
			}
			.flatMap { ids -> Single<Result<Data, APIError>> in
				if ids.count > 1 { return self.apiManager.request(EpisodeTarget.episodesWith(ids: ids)) }
				return .never()
			}
			.mapDecodable(from: [EpisodeModel].self)
						
			let episodeRequest = Observable.amb([singleEpisodeRequest, multipleEpisodeRequest])
									
			let obsZip = Observable.zip(characterRequest, locationRequest, originRequest, episodeRequest)
				.map { characterRequest, locationRequest, originRequest, episodeRequest -> Result<CharacterModel, APIError> in
					
					if case .success(let locations) = locationRequest, case .success(let origins) = originRequest,
						 case .success(let episodes) = episodeRequest, case .success(let character) = characterRequest {
						self.dbManager.saveLocation(location: locations)
						self.dbManager.saveLocation(location: origins)
						self.dbManager.saveEpisodes(episodes: episodes)
						self.dbManager.saveCharacter(character: character)
						return .success(character)
					}
					
					if let error = [locationRequest.error, originRequest.error, episodeRequest.error, characterRequest.error].error {
						return .failure(error)
					}
					return .failure(.requestFailed)
				}
				.bind(to: observable)
				
			return Disposables.create {
				characterObs.dispose()
				obsZip.dispose()
			}
		}
	}
  
	func filterCharacters(query: String) -> Observable<[CharacterModel]>  {
		return dbManager.filterObjects(ofType: CharacterModel.self, query: query)
			.map { $0.toArray() }
			.asObservable()
	}
	
	func filterLocations(query: String) -> Observable<[LocationModel]> {
		return dbManager.filterObjects(ofType: LocationModel.self, query: query)
			.map { $0.toArray() }
			.asObservable()
	}
}

