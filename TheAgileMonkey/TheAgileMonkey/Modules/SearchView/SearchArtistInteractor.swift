import Foundation

protocol SearchArtistInteractorInput: class {
    func searchArtistByName(_ name: String, page: Int)
}

protocol SearchArtistInteractorOutput: class {
    func artistsFetched(_ artistList: [Artist]?)
}

class SearchArtistInteractor: SearchArtistInteractorInput {
    
    weak var output: SearchArtistInteractorOutput?
    var networkManager: NetworkManager?
    
    func searchArtistByName(_ name: String, page: Int) {
        networkManager?.findArtists(page: page, name: name, completion: { [weak self] (data) in
            do {
                let artistsResponse = try JSONDecoder().decode(ArtistResponse.self, from: data)
                self?.output?.artistsFetched(artistsResponse.results)
                //self?.searchAtistAlbums(artistId: artistsResponse.results?.first?.artistId ?? 0)
            } catch let error {
                print(error.localizedDescription)
            }
        })
    }
    
    func searchAtistAlbums(artistId: Int32) {
        networkManager?.findAlbums(page: 0, artistId: artistId, completion: { [weak self] (data) in
            do {
                let artistsResponse = try JSONDecoder().decode(AlbumResponse.self, from: data)
                if let responseCount = artistsResponse.resultCount, responseCount > 0 {
                    let filteredData = artistsResponse.results?.filter({$0.wrapperType != "artist"})
                    self?.searchSongsForAlbum(id: filteredData?.first?.collectionId ?? 0)
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
    }
    
    func searchSongsForAlbum(id albumId: Int32) {
        networkManager?.findSongs(page: 0, albumId: albumId, completion: { [weak self] (data) in
            do {
                let artistsResponse = try JSONDecoder().decode(SongResponse.self, from: data)
                if let responseCount = artistsResponse.resultCount, responseCount > 0 {
                    let filteredData = artistsResponse.results?.filter({$0.wrapperType != "collection"})
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
    }
    
}
