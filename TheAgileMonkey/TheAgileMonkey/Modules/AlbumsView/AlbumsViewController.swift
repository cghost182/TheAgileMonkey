import Foundation
import UIKit

private struct Constants {
    static let albumCellReusableIdentifier = "AlbumTableViewCell"
}

protocol AlbumsViewProtocol: class {
    func refreshTable()
    func showError()
}

class AlbumsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var albumTableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Properties
    var presenter: AlbumsPresenterInput?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.updateView()
        showSpinner()
    }
    
    private func configureView() {
        setupTableView()
        setupBackButton()
        setupErrorLabel(isHidden: true)
    }
    
    private func setupTableView() {
        albumTableView.dataSource = self
    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        backButton.adjustsImageWhenHighlighted = false
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setupErrorLabel(isHidden: Bool) {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = isHidden
        }
    }
    
    @objc func backButtonPressed() {
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension AlbumsViewController: AlbumsViewProtocol {
    func refreshTable() {
        DispatchQueue.main.async {
            self.hideSpinner()
            self.setupErrorLabel(isHidden: true)
            self.title = self.presenter?.getArtistName()
            self.albumTableView.reloadData()
        }
    }
    
    func showError() {
        hideSpinner()
        setupErrorLabel(isHidden: false)
    }
}

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.albumsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumTableView.dequeueReusableCell(withIdentifier: Constants.albumCellReusableIdentifier, for: indexPath) as! AlbumTableViewCell
        cell.configure(with: presenter?.albumsArray[indexPath.row])
        return cell
    }
}

