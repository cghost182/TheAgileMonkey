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
    
    private var albumId: Int32?
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        guard let url = url,
              let imageURL = URL(string: url) else { return }
        
        DispatchQueue.global().async { [weak self] in
            guard let imageData = try? Data(contentsOf: imageURL) else {
                return
            }
                        
            DispatchQueue.main.async {
                let image = UIImage(data: imageData)
                self?.albumImageView.image = image
            }
        }
    }
}
