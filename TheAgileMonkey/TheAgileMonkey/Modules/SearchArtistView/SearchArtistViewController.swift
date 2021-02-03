import Foundation
import UIKit

private struct Constants {
    static let artistCellReusableIdentifier = "ArtistTableViewCell"
    static let title = "Monkey's tunes"
    static let searchPlaceholder = "Find an artist"
    static let errorLabel = "Artist not found"
    static let cellHeight: CGFloat = 70
}

protocol SearchArtistViewProtocol: class {
    func showResults()
    func showError()
}

class SearchArtistViewController: UIViewController, Throttable {
    
    //MARK: - Outlets
    @IBOutlet weak var artistsTable: UITableView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    //MARK: - Properties
    var presenter: SearchArtistPresenterInput?
    var searchController = UISearchController(searchResultsController: nil)
    private var isLoading: Bool = false
    private var searchText = ""
    private var viewIsAppearing = false
    
    lazy var performRequest = perform(with: 0.5) { [weak self] in
        guard let self = self else { return }
        
        self.showSpinner()
        self.presenter?.searchArtistByName(self.searchText)
    }
    
    lazy var cancelPreviousRequest = perform(with: 0.5) { [weak self] in
        self?.presenter?.resetArtistList()
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        viewIsAppearing = true
    }
    
    private func configureView() {
        title = Constants.title
        emptyListLabel.isHidden = false
        
        configureSearchController()
        configureTableView()
    }
    
    private func configureTableView() {
        artistsTable.delegate = self
        artistsTable.dataSource = self
        artistsTable.isHidden = true
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = Constants.searchPlaceholder
        
        navigationItem.searchController = searchController
    }
}

extension SearchArtistViewController: SearchArtistViewProtocol {
    func showResults() {
        hideSpinner()
        let hasResults = (self.presenter?.artistList.count ?? 0) > 0
        isLoading = false
        
        DispatchQueue.main.async {
            self.emptyListLabel.isHidden = hasResults
            self.artistsTable.isHidden = !hasResults
            self.artistsTable.reloadData()
        }
    }
    
    func showError() {
        hideSpinner()
        DispatchQueue.main.async {
            self.emptyListLabel.text = Constants.errorLabel
            self.emptyListLabel.isHidden = false
            self.artistsTable.isHidden = true
        }
    }
}

extension SearchArtistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.artistList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let artistListCount = presenter?.artistList.count,
              artistListCount > indexPath.row else { return UITableViewCell() }
        
        let cell = artistsTable.dequeueReusableCell(withIdentifier: Constants.artistCellReusableIdentifier, for: indexPath) as! ArtistTableViewCell
        cell.configure(with: presenter?.artistList[indexPath.row])
        return cell
    }
}

extension SearchArtistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artist = presenter?.artistList[indexPath.row]
        presenter?.navigateToAlbumsView(with: artist)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let artistListCount = presenter?.artistList.count ?? 0
        
        if (offsetY > contentHeight - scrollView.frame.height) && !isLoading && artistListCount > 0 {
            presenter?.loadMoreArtists()
            isLoading = true
        }
    }
}

extension SearchArtistViewController: UISearchResultsUpdating {
   
    func updateSearchResults(for searchController: UISearchController) {
        if viewIsAppearing {
            viewIsAppearing = false
            return
        }
        
        guard let text = searchController.searchBar.text,
              !text.isEmpty,
              text.count > 1 else {
            
            cancelPreviousRequest()
            return
        }
        
        searchText = text
        performRequest()
    }
    
}

extension SearchArtistViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.resetArtistList()
    }
}
