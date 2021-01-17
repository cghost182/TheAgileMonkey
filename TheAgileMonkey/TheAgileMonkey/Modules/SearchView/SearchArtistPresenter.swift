import Foundation

protocol SearchArtistPresenterInput: class {
    var artistList: [Artist] { get }
    func updateView()
    func searchArtistByName(_ name: String)
    func resetArtistList()
    func loadMoreArtists()
}

class SearchArtistPresenter: SearchArtistPresenterInput {
    
    var wireframe: SearchArtistWireframing?
    var interactor: SearchArtistInteractorInput?
    var artistList: [Artist] = []
    private var searchText = ""
    private var page = 0
    weak var view: SearchArtistViewProtocol?
    
    func updateView() {
        
    }
    
    func searchArtistByName(_ name: String) {
        searchText = name
        page = 0
        interactor?.searchArtistByName(name, page: page)
    }
    
    func resetArtistList() {
        artistList = []
        searchText = ""
        view?.showResults()
    }
    
    func loadMoreArtists() {
        page += 1
        interactor?.searchArtistByName(searchText, page: page)
    }
}

extension SearchArtistPresenter: SearchArtistInteractorOutput {
    func artistsFetched(_ artistListFetched: [Artist]?) {
        guard let artistListFetched = artistListFetched,
              artistListFetched.count > 0 else {
            return
        }
        
        if page == 0 {
            self.artistList = artistListFetched
        } else {
            self.artistList += artistListFetched
        }
        
        view?.showResults()
    }
}