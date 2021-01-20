import Foundation
import UIKit

private let SongsStoryboard = "Songs"
private let SongsViewControllerIdentifier = "SongsViewController"

protocol SongsWireframing {
    static func createSongs(with album: Album?) -> SongsViewController
}

class SongsWireframe {
    
    fileprivate weak var viewController: SongsViewController?
    
    fileprivate class func createSongsViewController() -> SongsViewController {
        // create module objects
        let view = viewControllerFromStoryboard()
        let wireframe = SongsWireframe()
        let presenter = SongsPresenter()
        let interactor = SongsInteractor()
        
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
    
    fileprivate class func viewControllerFromStoryboard() -> SongsViewController {
        let storyboard = storyboardForWireframe()
        let viewController = storyboard.instantiateViewController(withIdentifier:SongsViewControllerIdentifier) as! SongsViewController
        return viewController
    }
    
    fileprivate class func storyboardForWireframe() -> UIStoryboard {
        let storyboard = UIStoryboard(name: SongsStoryboard, bundle: Bundle.main)
        return storyboard
    }
}

extension SongsWireframe: SongsWireframing {
    
    //MARK: Static Creation Methods (called by other modules)
    
    static func createSongs(with album: Album?) -> SongsViewController {
        let songsViewController = createSongsViewController()
        songsViewController.presenter?.handleIncoming(album: album)
        return songsViewController
    }
    
    //MARK: Presentation Methods (called by this module)
    
    
}
