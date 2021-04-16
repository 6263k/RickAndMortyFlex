//
//  DBManager.swift
//  RickAndMortyFlexx
//
//  Created by Даниил on 26.03.2021.
//
import RealmSwift
import RxSwift
import RxRealm

final class DBManager {
  let realm: Realm
  let configuration: Realm.Configuration
  
  init?(config: Realm.Configuration){
    self.configuration = config

    do {
      self.realm = try Realm(configuration: config)
    } catch let error as NSError {
      print("Realm unresolved error has occured\(error.localizedDescription)")
      return nil
    }
  }
  
  convenience init?() {
    var defaultConfiguration: Realm.Configuration {
      let documentsUrl = try! FileManager.default
          .url(for: .documentDirectory, in: .userDomainMask,
            appropriateFor: nil, create: false)
          .appendingPathComponent("myRealm.realm")
      let objectTypes = [LocationModel.self, CharacterModel.self, EpisodeModel.self]
      return Realm.Configuration.init(fileURL: documentsUrl, schemaVersion: 1, migrationBlock: {_,_ in }, deleteRealmIfMigrationNeeded: false, objectTypes: objectTypes)
    }
    self.init(config: defaultConfiguration)
  }
  
  
  func saveCharacters(characters: [CharacterModel]) {
    var locationsID: [Int?] = []
    var originsID: [Int?] = []
    var nestedEpisodesID: [[Int]?] = []
    
    characters.forEach {
      locationsID.append($0.getLocationIDFromAPI())
      originsID.append($0.getOriginIDFromAPI())
      nestedEpisodesID.append($0.getEpisodesIDFromAPI())
    }
    
    objectsCreateIfNotExist(for: LocationModel.self, IDs: locationsID)
    objectsCreateIfNotExist(for: LocationModel.self, IDs: originsID)
    createObjectsFromNestedArray(for: EpisodeModel.self, nestedIDs: nestedEpisodesID)
    
    characters.forEach { [weak self]  character in
      
      if let locationID = character.getLocationIDFromAPI() {
        character.location = (self?.realm.object(ofType: LocationModel.self, forPrimaryKey: locationID))!
      }
      
      if let originID = character.getOriginIDFromAPI() {
        character.origin = (self?.realm.object(ofType: LocationModel.self, forPrimaryKey: originID))!
      }
      
      if let episodesID = character.getEpisodesIDFromAPI() {
        episodesID.forEach { episodeID in
          if let episode = self?.realm.object(ofType: EpisodeModel.self, forPrimaryKey: episodeID),
             !character.episode.contains(episode) {
            character.episode.append(episode)
          }
        }
      }
    }
    
    realm.safeWrite {
      realm.add(characters, update: .modified)
    }
  }
  
  func saveCharacter(character: CharacterModel) {
    saveCharacters(characters: [character])
  }
  
  func saveLocations(locations: [LocationModel]) {
    var nestedCharactersID: [[Int]?] = []
    locations.forEach {
      nestedCharactersID.append($0.getResidentsIDFromAPI())
    }
    createObjectsFromNestedArray(for: CharacterModel.self, nestedIDs: nestedCharactersID)
    
    locations.forEach { [weak self] location in
      if let charactersID = location.getResidentsIDFromAPI() {
        charactersID.forEach { characterID in
          if let character = self?.realm.object(ofType: CharacterModel.self, forPrimaryKey: characterID),
             !location.characters.contains(character) {
            location.characters.append(character)
          }
        }
      }
    }
    
    realm.safeWrite {
      realm.add(locations, update: .modified)
    }
  }
  
  func saveLocation(location: LocationModel) {
    saveLocations(locations: [location])
  }
  
  func saveEpisodes(episodes: [EpisodeModel]) {
    var nestedCharactersID: [[Int]?] = []
    episodes.forEach {
      nestedCharactersID.append($0.getCharactersIDFromAPI())
    }
    createObjectsFromNestedArray(for: CharacterModel.self, nestedIDs: nestedCharactersID)
    
    episodes.forEach { [weak self] episode in
      if let charactersID = episode.getCharactersIDFromAPI() {
        charactersID.forEach { characterID in
          if let character = self?.realm.object(ofType: CharacterModel.self, forPrimaryKey: characterID),
             !episode.characters.contains(character) {
            episode.characters.append(character)
          }
        }
      }
    }
    
    realm.safeWrite {
      realm.add(episodes, update: .modified)
    }
  }
  
  func getObjects<Element: Object>(ofType objectType: Element.Type) -> Observable<Results<Element>> {
    let objects = realm.objects(objectType)
    return Observable.collection(from: objects)
  }
  
  func getObjectsWithIDs<Element: Object>(ofType objectType: Element.Type, IDs: [Int]) -> Observable<Results<Element>> {
    let objects = realm.objects(objectType).filter("id IN %d", IDs)
    return Observable.collection(from: objects)
  }
  
  func getObjectWithID<Element: Object>(ofType objectType: Element.Type, ID: Int) -> Observable<Results<Element>> {
    return getObjectsWithIDs(ofType: objectType, IDs: [ID])
  }
  
	func filterObjects<T: Object>(ofType type: T.Type, query: String) -> Observable<Results<T>> {
		let objects = realm.objects(type).filter("name CONTAINS %d", query)
		return Observable.collection(from: objects)
	}
}

//MARK: - Private
extension DBManager {
  private func objectsCreateIfNotExist<Element: IDInitable>(for objectType: Element.Type, IDs: [Int?]) {
    var objectsToAdd = [Element]()
    
    IDs.compactMap({ $0 }).unique.forEach { [weak self] ID in
      guard let self = self,
            !self.realm.checkObjectExists(objectType: objectType, id: ID) else { return }
      objectsToAdd.append(objectType.init(id: ID))
    }
    
    realm.safeWrite {
			realm.add(objectsToAdd, update: .modified)
    }
  }


  private func createObjectsFromNestedArray<Element: IDInitable>(for objectType: Element.Type, nestedIDs: [[Int]?]) {
    var objectsToAdd = [Element]()
    let IDs = nestedIDs.compactMap({ $0 }).reduce([], +).unique
    IDs.forEach { [weak self] ID in
      guard let self = self,
        !self.realm.checkObjectExists(objectType: objectType, id: ID) else { return }
      objectsToAdd.append(objectType.init(id: ID))
    }
    
    realm.safeWrite {
			realm.add(objectsToAdd, update: .modified)
    }
  }
	

}


