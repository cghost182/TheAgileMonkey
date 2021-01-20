import Foundation

protocol SongsPresenterInput: class {
    var songsArray: [Song] { get }
    func updateView()
    func handleIncoming(album: Album?)
    func getAlbumName() -> String?
}

class SongsPresenter: SongsPresenterInput {
    
    var wireframe: SongsWireframing?
    var interactor: SongsInteractorInput?
    var album: Album?
    var songsArray: [Song] = []
    weak var view: SongsViewProtocol?
    
    func updateView() {
        interactor?.fethSongsFor(album: album)
    }
    
    func handleIncoming(album: Album?) {
        self.album = album
    }
    
    func getAlbumName() -> String? {
        return album?.collectionName
    }
}

extension SongsPresenter: SongsInteractorOutput {
    func songsFetched(with songs: [Song]) {
        songsArray = songs
        view?.refreshSongsList()
    }
    
    func songsNotFound() {
        view?.showError()
    }
}
