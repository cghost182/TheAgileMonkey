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
    var networkManager: NetworkManagerInput?
    
    func searchArtistByName(_ name: String, page: Int) {
        networkManager?.findArtists(page: page, name: name, completion: { [weak self] (data) in
            do {
                let artistsResponse = try JSONDecoder().decode(ArtistResponse.self, from: data)
                if let results = artistsResponse.results, results.count > 0 {
                    self?.output?.artistsFetched(results)
                } else {
                    self?.output?.artistNotFound()
                }
            } catch let error {
                self?.output?.artistNotFound()
                print(error.localizedDescription)
            }
        })
    }
}
