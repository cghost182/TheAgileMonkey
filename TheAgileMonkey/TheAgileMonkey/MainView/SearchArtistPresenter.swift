import Foundation

protocol SearchArtistPresenterInput: class {
    func updateView()
    func searchArtistByName(_ name: String)
}

class SearchArtistPresenter: SearchArtistPresenterInput {
    
    var wireframe: SearchArtistWireframing?
    var interactor: SearchArtistInteractorInput?
    
    weak var view: SearchArtistViewProtocol?
    
    func updateView() {
        
    }
    
    func searchArtistByName(_ name: String) {
        interactor?.searchArtistByName("Maroon")
    }
}

extension SearchArtistPresenter: SearchArtistInteractorOutput {
    
    
}
