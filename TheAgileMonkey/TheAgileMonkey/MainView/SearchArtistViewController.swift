import Foundation
import UIKit

protocol SearchArtistViewProtocol: class {
    
}

class SearchArtistViewController: UIViewController {
    
    var presenter: SearchArtistPresenterInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.updateView()
    }
    
    func configureView() {
        
        
    }
    
    // MARK: - IBActions
    @IBAction func findButtonTapped(_ sender: Any) {
        presenter?.searchArtistByName("Linkin")
    }
    
    
}

extension SearchArtistViewController: SearchArtistViewProtocol {
    
}
