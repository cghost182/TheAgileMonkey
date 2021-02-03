import Foundation

protocol SongsPresenterInput: class {
    var songsArray: [Song] { get }
    func updateView()
    func handleIncoming(album: Album?)
    func getAlbumName() -> String?
    func handleFavoriteButtonTapped(songId: Int32)
}

class SongsPresenter: SongsPresenterInput {
    
    var wireframe: SongsWireframing?
    var interactor: SongsInteractorInput?
    var album: Album?
    var songsArray: [Song] = []
    private let dispatchGroup = DispatchGroup()
    weak var view: SongsViewProtocol?
    
    func updateView() {
        dispatchGroup.enter()
        interactor?.fethSongsFor(album: album)
        
        dispatchGroup.enter()
        interactor?.loadStoredSongs()
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.view?.refreshSongsList()
        }
    }
    
    func handleIncoming(album: Album?) {
        self.album = album
    }
    
    func getAlbumName() -> String? {
        return album?.collectionName
    }
    
    func handleFavoriteButtonTapped(songId: Int32) {
        interactor?.handleFavoriteButtonTapped(songId: songId)
    }
    
    private func isLikedSong(songId: Int32) -> Bool {
        return interactor?.isSongCurrentlyStored(songIdString: String(songId), deleteOccurrences: false) ?? false
    }
}

extension SongsPresenter: SongsInteractorOutput {
    func songsFetched(with songs: [Song]) {
        songsArray = songs
        
        for (index, song) in songsArray.enumerated() {
            if let trackId = song.trackId {
                songsArray[index].isFavorite = isLikedSong(songId: trackId)
            }
        }
        
        dispatchGroup.leave()
    }
    
    func storedSongsFetched() {
        dispatchGroup.leave()
    }
    
    func songsNotFound() {
        view?.showError()
    }
}
