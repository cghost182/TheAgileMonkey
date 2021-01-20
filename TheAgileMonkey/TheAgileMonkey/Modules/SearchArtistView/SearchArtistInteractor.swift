import Foundation

protocol SearchArtistInteractorInput: class {
    func searchArtistByName(_ name: String, page: Int)
}

protocol SearchArtistInteractorOutput: class {
    func artistsFetched(_ artistList: [Artist]?)
    func artistNotFound()
}

class SearchArtistInteractor: SearchArtistInteractorInput {
    
    weak var output: SearchArtistInteractorOutput?
    var networkManager: NetworkManager?
    
    func searchArtistByName(_ name: String, page: Int) {
        networkManager?.findArtists(page: page, name: name, completion: { [weak self] (data) in
            do {
                let artistsResponse = try JSONDecoder().decode(ArtistResponse.self, from: data)
                self?.output?.artistsFetched(artistsResponse.results)
            } catch let error {
                self?.output?.artistNotFound()
                print(error.localizedDescription)
            }
        })
    }
}
