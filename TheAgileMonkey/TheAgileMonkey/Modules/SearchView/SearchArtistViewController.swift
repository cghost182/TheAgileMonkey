import Foundation
import UIKit

private struct Constants {
    static let artistCellReusableIdentifier = "ArtistTableViewCell"
    static let title = "Monkey's tunes"
    static let searchPlaceholder = "Find an artist"
    static let cellHeight: CGFloat = 70
}

protocol SearchArtistViewProtocol: class {
    func showResults()
}

class SearchArtistViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var artistsTable: UITableView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    //MARK: - Properties
    var presenter: SearchArtistPresenterInput?
    var searchController: UISearchController?
    private var isLoading: Bool = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.updateView()
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
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.delegate = self
        searchController?.searchBar.placeholder = Constants.searchPlaceholder
        
        navigationItem.searchController = searchController
    }
}

extension SearchArtistViewController: SearchArtistViewProtocol {
    func showResults() {
        let hasResults = (self.presenter?.artistList.count ?? 0) > 0
        isLoading = false
        
        DispatchQueue.main.async {
            self.emptyListLabel.isHidden = hasResults
            self.artistsTable.isHidden = !hasResults
            self.artistsTable.reloadData()
        }
    }
}

extension SearchArtistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.artistList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        guard let text = searchController.searchBar.text,
              !text.isEmpty,
              text.count > 2 else {
            
            presenter?.resetArtistList()
            return
        }
        presenter?.searchArtistByName(text)
    }
    
}

extension SearchArtistViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.resetArtistList()
    }
}
