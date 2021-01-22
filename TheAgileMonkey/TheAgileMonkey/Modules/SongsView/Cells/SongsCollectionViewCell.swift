//
//  SongsCollectionViewCell.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 19/01/21.
//

import UIKit


class SongsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songsContentView: UIView!
    @IBOutlet weak var songimageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var likeButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    var audioURLString: String?
    var likedSong: Bool = false
    var songDownloaded = false
    var isPlayingAudio: Bool? {
        didSet {
            togglePlayIcon()
        }
    }
    let audioManager = AudioManager.shared
    
    func configure(with song: Song?) {
        guard let song = song else { return }
        
        songNameLabel.text = song.trackName
        audioURLString = song.previewUrl
        loadImage(url: song.artworkUrl100)
        hideActivityIndicator()
        subscribeForNotifications()
    }
    
    private func subscribeForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(stopPlaying), name: .audioManagerStopPlaying, object: nil)
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
    
    func togglePlayIcon() {
        DispatchQueue.main.async {
            if self.isPlayingAudio ?? false {
                self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            } else {
                self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.playButton.isHidden = true
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
        
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.playButton.isHidden = false
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc func stopPlaying() {
        self.isPlayingAudio = false
    }
    
    //MARK: - Actions
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            if self.likedSong {
                UIView.animate(withDuration: 2.0) {
                    self.likeButtonWidthConstraint.constant = 0
                } completion: { (finished) in
                    self.likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                    self.likeButtonWidthConstraint.constant = 21
                }
            } else {
                UIView.animate(withDuration: 2.0) {
                    self.likeButtonWidthConstraint.constant = 0
                } completion: { (finished) in
                    self.likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
                    self.likeButtonWidthConstraint.constant = 21
                }
            }
            self.likedSong = !self.likedSong
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if !songDownloaded {
            showActivityIndicator()
            audioManager.downloadFileFromURL(audioURLString) { [weak self] isSongDownloaded in
                self?.isPlayingAudio = isSongDownloaded
                self?.songDownloaded = isSongDownloaded
                self?.hideActivityIndicator()
            }
            return
        }
        
        if isPlayingAudio ?? false {
            audioManager.stopSound()
            self.isPlayingAudio = false
        } else {
            audioManager.playSound()
            self.isPlayingAudio = true
        }
    }
}


