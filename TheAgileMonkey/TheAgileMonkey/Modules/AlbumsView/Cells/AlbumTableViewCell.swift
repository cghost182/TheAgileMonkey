//
//  AlbumTableViewCell.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 18/01/21.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var albumId: Int32?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    private func resetView() {
        albumImageView.image = nil
        albumNameLabel.text = ""
        releaseDateLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with album: Album?) {
        guard let album = album else { return }
        
        loadImage(url: album.artworkUrl60)
        albumId = album.collectionId
        albumNameLabel.text = album.collectionName
        releaseDateLabel.text = album.releaseDate?.getDateFromString()
    }
    
    private func loadImage(url: String?) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        ImageLoader.loadImage(url: url) { [weak self] (image) in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.albumImageView.image = image
        }
    }
}

