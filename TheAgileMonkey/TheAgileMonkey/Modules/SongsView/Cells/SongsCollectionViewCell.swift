//
//  SongsCollectionViewCell.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 19/01/21.
//

import UIKit

class SongsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songsContentView: UIView!
    @IBOutlet weak var songimageView: UIImageView!
    
    func configure(with song: Song?) {
        guard let song = song else { return }
        
        songNameLabel.text = song.trackName
        loadImage(url: song.artworkUrl100)
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
                self?.songimageView.image = image
            }
        }
    }
}
