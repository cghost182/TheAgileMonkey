import Foundation
import UIKit

private let AlbumsStoryboard = "Albums"
private let AlbumsViewControllerIdentifier = "AlbumsViewController"

protocol AlbumsWireframing {
    static func createAlbums(with artist: Artist?) -> AlbumsViewController
    func navigateToSongsView(with album: Album?)
}

class AlbumsWireframe {
    
    fileprivate weak var viewController: AlbumsViewController?
    
    fileprivate class func createAlbumsViewController() -> AlbumsViewController {
        // create module objects
        let view = viewControllerFromStoryboard()
        let wireframe = AlbumsWireframe()
        let presenter = AlbumsPresenter()
        let interactor = AlbumsInteractor()
        
        // create/access additional/shared objects
        let networkManager = NetworkManager.shared
        
        // wire in shared object dependencies
        interactor.networkManager = networkManager
        
        // wire in module dependencies
        wireframe.viewController = view
        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.output = presenter
        
        return view
    }
    
    fileprivate class func viewControllerFromStoryboard() -> AlbumsViewController {
        let storyboard = storyboardForWireframe()
        let viewController = storyboard.instantiateViewController(withIdentifier:AlbumsViewControllerIdentifier) as! AlbumsViewController
        return viewController
    }
    
    fileprivate class func storyboardForWireframe() -> UIStoryboard {
        let storyboard = UIStoryboard(name: AlbumsStoryboard, bundle: Bundle.main)
        return storyboard
    }
}

extension AlbumsWireframe: AlbumsWireframing {
    
    //MARK: Static Creation Methods (called by other modules)
    
    static func createAlbums(with artist: Artist?) -> AlbumsViewController {
        let albumsViewController = createAlbumsViewController()
        albumsViewController.presenter?.handleIncoming(artist: artist)
        return albumsViewController
    }
    
    //MARK: Presentation Methods (called by this module)
    
    func navigateToSongsView(with album: Album?) {
        let songsViewController = SongsWireframe.createSongs(with: album)
        viewController?.navigationController?.pushViewController(songsViewController, animated: true)
    }
}
