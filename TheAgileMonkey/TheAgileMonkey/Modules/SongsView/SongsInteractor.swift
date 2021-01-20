import Foundation

protocol SongsInteractorInput: class {
    func fethSongsFor(album: Album?)
}

protocol SongsInteractorOutput: class {
    func songsFetched(with songs: [Song])
    func songsNotFound()
}

class SongsInteractor: SongsInteractorInput {
    
    weak var output: SongsInteractorOutput?
    var networkManager: NetworkManager?
    
    func fethSongsFor(album: Album?) {
        guard let album = album,
              let albumId = album.collectionId else { return }
        
        networkManager?.findSongs(page: 0, albumId: albumId, completion: { [weak self] (data) in
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
    
}
