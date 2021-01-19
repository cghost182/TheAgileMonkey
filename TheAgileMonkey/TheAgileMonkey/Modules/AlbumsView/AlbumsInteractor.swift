import Foundation

protocol AlbumsInteractorInput: class {
    func fetchAlbumsFor(_ artist: Artist?)
}

protocol AlbumsInteractorOutput: class {
    func albumsFetched(with albums: [Album])
    func albumsNotFound()
}

class AlbumsInteractor: AlbumsInteractorInput {
    
    weak var output: AlbumsInteractorOutput?
    var networkManager: NetworkManager?
    
    func fetchAlbumsFor(_ artist: Artist?) {
        guard let artist = artist,
              let artistId = artist.artistId else {
            print("Error getting artist Id")
            return
        }
        
        networkManager?.findAlbums(artistId: artistId, completion: { [weak self] (data) in
            do {
                let albumsResponse = try JSONDecoder().decode(AlbumResponse.self, from: data)
                if let responseCount = albumsResponse.resultCount, responseCount > 0 {
                    let albums = albumsResponse.results?.filter({$0.wrapperType != "artist"})
                    
                    guard let albumsFiletered = albums, albumsFiletered.count > 0 else {
                        self?.output?.albumsNotFound()
                        return
                    }
                    
                    self?.output?.albumsFetched(with: albumsFiletered)
                } else {
                    self?.output?.albumsNotFound()
                }
                
            } catch let error {
                self?.output?.albumsNotFound()
                print(error.localizedDescription)
            }
        })
    }
    
}
