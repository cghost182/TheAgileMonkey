import Foundation

protocol AlbumsPresenterInput: class {
    var albumsArray: [Album] { get }
    func updateView()
    func handleIncoming(artist: Artist?)
    func getArtistName() -> String?
    func navigateToSongsView(with album: Album?)
}

class AlbumsPresenter: AlbumsPresenterInput {
    
    var wireframe: AlbumsWireframing?
    var interactor: AlbumsInteractorInput?
    var albumsArray: [Album] = []
    private var artist: Artist?
    weak var view: AlbumsViewProtocol?
    
    func updateView() {
        interactor?.fetchAlbumsFor(artist)
    }
    
    func handleIncoming(artist: Artist?) {
        self.artist = artist
    }
    
    func getArtistName() -> String? {
        return artist?.artistName
    }
    
    func navigateToSongsView(with album: Album?) {
        wireframe?.navigateToSongsView(with: album)
    }
}

extension AlbumsPresenter: AlbumsInteractorOutput {
    func albumsFetched(with albums: [Album]) {
        self.albumsArray = albums
        view?.refreshTable()
    }
    
    func albumsNotFound() {
        view?.showError()
    }
}
