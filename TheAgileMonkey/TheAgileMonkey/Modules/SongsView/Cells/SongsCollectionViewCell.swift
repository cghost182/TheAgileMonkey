//
//  SongsCollectionViewCell.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 19/01/21.
//

import UIKit
import CoreData

protocol SongsCollectionViewCellDelegate: class {
    func favoriteIconTapped(with songId: Int32?)
}

private struct Constants {
    static let musicVideoType = "music-video"
}

class SongsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songsContentView: UIView!
    @IBOutlet weak var songimageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playVideoButton: UIButton!
    @IBOutlet weak var likeButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    weak var delegate: SongsCollectionViewCellDelegate?
    var audioURLString: String?
    var videoURLString: String?
    var likedSong: Bool = false
    var songDownloaded = false
    var isPlayingAudio: Bool? {
        didSet {
            togglePlayIcon()
        }
    }
    let audioManager = AudioManager.shared
    var songId: Int32?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resetView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }
    
    private func resetView() {
        likedSong = false
        songDownloaded = false
        likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        playVideoButton.isHidden = true
        audioURLString = nil
        videoURLString = nil
        songimageView.image = nil
    }
    
    func configure(with song: Song?, isLiked: Bool) {
        guard let song = song else { return }
        
        self.songId = song.trackId
        likedSong = isLiked
        songNameLabel.text = song.trackName
        loadImage(url: song.artworkUrl100)
        hideActivityIndicator()
        subscribeForNotifications()
        setLikeIcon()
        setMediaIcons(for: song)
    }
    
    private func setMediaIcons(for song: Song) {
        if let kind = song.kind,
           kind == Constants.musicVideoType,
           let videoUrl = song.previewUrl {
            videoURLString = videoUrl
            playButton.isHidden = true
            playVideoButton.isHidden = false
        } else {
            audioURLString = song.previewUrl
            playButton.isHidden = false
            playVideoButton.isHidden = true
        }
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
            if let _ = self.audioURLString {
                self.playButton.isHidden = true
            }
            
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            if let _ = self.audioURLString {
                self.playButton.isHidden = false
            }
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func setLikeIcon() {
        DispatchQueue.main.async {
            if self.likedSong {
                UIView.animate(withDuration: 2.0) {
                    self.likeButtonWidthConstraint.constant = 0
                } completion: { (finished) in
                    self.likeButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
                    self.likeButtonWidthConstraint.constant = 21
                }
            } else {
                UIView.animate(withDuration: 2.0) {
                    self.likeButtonWidthConstraint.constant = 0
                } completion: { (finished) in
                    self.likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
                    self.likeButtonWidthConstraint.constant = 21
                    
                }
            }
        }
    }
    
    @objc func stopPlaying() {
        audioManager.stopSound()
        isPlayingAudio = false
        songDownloaded = false
    }
    
    //MARK: - Actions
    @IBAction func likeButtonTapped(_ sender: Any) {
        likedSong = !likedSong
        delegate?.favoriteIconTapped(with: self.songId)
        setLikeIcon()
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if !songDownloaded && !(isPlayingAudio ?? false) {
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
            isPlayingAudio = false
        } else {
            audioManager.playSound()
            isPlayingAudio = true
        }
    }
    
    @IBAction func playVideoButtonTapped(_ sender: Any) {
        NotificationCenter.default.post(name: .audioManagerStopPlaying, object: nil)
        VideoManager.shared.playVideoURL(videoURLString)
    }
}


