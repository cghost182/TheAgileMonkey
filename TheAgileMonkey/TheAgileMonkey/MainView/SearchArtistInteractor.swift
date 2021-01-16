import Foundation

protocol SearchArtistInteractorInput: class {
    func searchArtistByName(_ name: String)
}

protocol SearchArtistInteractorOutput: class {
    
}

class SearchArtistInteractor: SearchArtistInteractorInput {
    
    weak var output: SearchArtistInteractorOutput?
    var networkManager: NetworkManager?
    
    func searchArtistByName(_ name: String) {
        networkManager?.findArtists(page: 1, name: name, completion: { [weak self] (data) in
            do {
                let artistsResponse = try JSONDecoder().decode(Artist.self, from: data)
                print(artistsResponse)
                self?.searchAtistAlbums(artistId: artistsResponse.results?.first?.artistId ?? 0)
            } catch let error {
                print(error.localizedDescription)
            }
        })
    }
    
    func searchAtistAlbums(artistId: Int32) {
        networkManager?.findAlbums(page: 1, artistId: artistId, completion: { [weak self] (data) in
            do {
                let artistsResponse = try JSONDecoder().decode(Album.self, from: data)
                if let responseCount = artistsResponse.resultCount, responseCount > 0 {
                    let filteredData = artistsResponse.results?.filter({$0.wrapperType != "artist"})
                    print(filteredData)
                    self?.searchSongsForAlbum(id: filteredData?.first?.collectionId ?? 0)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
    }
    
    func searchSongsForAlbum(id albumId: Int32) {
        networkManager?.findSongs(page: 1, albumId: albumId, completion: { [weak self] (data) in
            do {
                let artistsResponse = try JSONDecoder().decode(Song.self, from: data)
                if let responseCount = artistsResponse.resultCount, responseCount > 0 {
                    let filteredData = artistsResponse.results?.filter({$0.wrapperType != "collection"})
                    print(filteredData)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
    }
    
}
