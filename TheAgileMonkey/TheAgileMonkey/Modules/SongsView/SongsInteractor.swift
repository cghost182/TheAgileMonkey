import Foundation
import CoreData

private struct Constants {
    static let coreDataLikedSongsEntityName = "LikedSongs"
    static let coreDataLikedSongsEntityId = "id"
}

protocol SongsInteractorInput: class {
    func fethSongsFor(album: Album?)
    func loadStoredSongs()
    func handleFavoriteButtonTapped(songId: Int32)
    func isSongCurrentlyStored(songIdString: String, deleteOccurrences: Bool) -> Bool
}

protocol SongsInteractorOutput: class {
    func songsFetched(with songs: [Song])
    func songsNotFound()
    func storedSongsFetched()
}

class SongsInteractor: SongsInteractorInput {
    
    weak var output: SongsInteractorOutput?
    var networkManager: NetworkManager?
    var coreDataManagedSongs: [NSManagedObject] = []
    var appDelegate: AppDelegate?
    
    func fethSongsFor(album: Album?) {
        guard let album = album,
              let albumId = album.collectionId else { return }
        
        networkManager?.findSongs(albumId: albumId, completion: { [weak self] (data) in
            do {
                let artistsResponse = try JSONDecoder().decode(SongResponse.self, from: data)
                if let responseCount = artistsResponse.resultCount, responseCount > 0 {
                    let songs = artistsResponse.results?.filter({$0.wrapperType != "collection"})
                    
                    guard let songsFiltered = songs, songsFiltered.count > 0 else {
                        self?.output?.songsNotFound()
                        return
                    }
                    
                    self?.output?.songsFetched(with: songsFiltered)
                }
                
            } catch let error {
                self?.output?.songsNotFound()
                print(error.localizedDescription)
            }
        })
    }
    
    //MARK: - CoreData logic 
    private func getManagedContext() -> NSManagedObjectContext? {
        return appDelegate?.persistentContainer.viewContext
    }
    
    func loadStoredSongs() {
        if let managedContext = getManagedContext() {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.coreDataLikedSongsEntityName)
            
            do {
                coreDataManagedSongs = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        } else {
            print("error getting managed context")
        }
        output?.storedSongsFetched()
    }
    
    func handleFavoriteButtonTapped(songId: Int32) {
        let songIdString = String(songId)
        
        guard !isSongCurrentlyStored(songIdString: songIdString, deleteOccurrences: true) else {
            return
        }
        
        saveSong(songIdString: songIdString)
    }
    
    func saveSong(songIdString: String) {
        if let managedContext = getManagedContext(),
           let entity = NSEntityDescription.entity(forEntityName: Constants.coreDataLikedSongsEntityName, in: managedContext) {
            
            let songEntity = NSManagedObject(entity: entity, insertInto: managedContext)
            songEntity.setValue(songIdString, forKeyPath: Constants.coreDataLikedSongsEntityId)
            
            do {
                try managedContext.save()
                coreDataManagedSongs.append(songEntity)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        } else {
            print("error getting managed Context")
        }
    }
    
    func isSongCurrentlyStored(songIdString: String, deleteOccurrences: Bool = false) -> Bool {
        if let managedContext = getManagedContext() {
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.coreDataLikedSongsEntityName)
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", String(songIdString))
            do {
                let results = try managedContext.fetch(fetchRequest)
                let hasOccurrences = results.count > 0
                
                if deleteOccurrences && hasOccurrences {
                    for occurrence in results {
                        managedContext.delete(occurrence)
                    }
                    try managedContext.save()
                }
                
                return hasOccurrences
            } catch _ as NSError {
                return false
            }
        }
        return false
    }
}
