import Foundation
import UIKit

private struct Constants {
    static let songsCellReusableIdentifier = "SongCellId"
}
protocol SongsViewProtocol: class {
    func refreshSongsList()
    func showError()
}

class SongsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var songsCollectionView: UICollectionView!
    @IBOutlet weak var errorLabel: UILabel!
    
    //MARK: - Properties
    var presenter: SongsPresenterInput?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.updateView()
        showSpinner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        AudioManager.shared.stopSound()
    }
    
    private func configureView() {
        title = presenter?.getAlbumName()
        setupCollectionView()
        setupBackButton()
        self.setupErrorLabel(isHidden: true)
    }
    
    private func setupCollectionView() {
        songsCollectionView.delegate = self
        songsCollectionView.dataSource = self
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

extension SongsViewController: SongsViewProtocol {
    func refreshSongsList() {
        DispatchQueue.main.async {
            self.hideSpinner()
            self.setupErrorLabel(isHidden: true)
            self.songsCollectionView.reloadData()
        }
    }
    
    func showError() {
        DispatchQueue.main.async {
            self.hideSpinner()
            self.setupErrorLabel(isHidden: false)
        }
    }
}

extension SongsViewController: UICollectionViewDelegate {
    
}

extension SongsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.songsArray.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let song = presenter?.songsArray[indexPath.row]
        let cell = songsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.songsCellReusableIdentifier, for: indexPath) as! SongsCollectionViewCell
        cell.configure(with: song)
        return cell
    }
}
