import Foundation
import UIKit

private let SearchArtistStoryboard = "SearchArtist"
private let SearchArtistViewControllerIdentifier = "SearchArtistViewController"

protocol SearchArtistWireframing {
    
    static func createSearchArtist() -> SearchArtistViewController 
}

class SearchArtistWireframe {
    
    fileprivate weak var viewController: SearchArtistViewController?
    
    fileprivate class func createSearchArtistViewController() -> SearchArtistViewController {
        // create module objects
        let view = viewControllerFromStoryboard()
        let wireframe = SearchArtistWireframe()
        let presenter = SearchArtistPresenter()
        let interactor = SearchArtistInteractor()
        
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
    
    fileprivate class func viewControllerFromStoryboard() -> SearchArtistViewController {
        let storyboard = storyboardForWireframe()
        let viewController = storyboard.instantiateViewController(withIdentifier:SearchArtistViewControllerIdentifier) as! SearchArtistViewController
        return viewController
    }
    
    fileprivate class func storyboardForWireframe() -> UIStoryboard {
        let storyboard = UIStoryboard(name: SearchArtistStoryboard, bundle: Bundle.main)
        return storyboard
    }
}

extension SearchArtistWireframe: SearchArtistWireframing {
    
    //MARK: Static Creation Methods (called by other modules)
    
    static func createSearchArtist() -> SearchArtistViewController {
        return createSearchArtistViewController()
    }
    
    //MARK: Presentation Methods (called by this module)
    
    
}
