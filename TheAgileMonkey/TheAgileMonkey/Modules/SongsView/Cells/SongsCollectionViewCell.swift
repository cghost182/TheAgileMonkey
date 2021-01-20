//
//  SongsCollectionViewCell.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 19/01/21.
//

import UIKit
import AVFoundation

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
    var player: AVAudioPlayer?
    var audioURLString: String?
    var likedSong: Bool = false
    var isPlayingAudio: Bool? {
        didSet {
            togglePlayIcon()
        }
    }
    
    func configure(with song: Song?) {
        guard let song = song else { return }
        
        songNameLabel.text = song.trackName
        audioURLString = song.previewUrl
        loadImage(url: song.artworkUrl100)
        hideActivityIndicator()
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
    
    func playSound(with url: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp4.rawValue)

            guard let player = player else { return }

            player.play()
            player.delegate = self
            isPlayingAudio = true

        } catch let error {
            print(error.localizedDescription)
        }
    }

    func downloadFileFromURL(){
        guard let urlString = audioURLString,
              let url = URL(string: urlString) else { return }
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            self.playSound(with: url!)
            self.hideActivityIndicator()
        }
        downloadTask.resume()
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
        guard let isPlayingAudio = isPlayingAudio else {
            showActivityIndicator()
            downloadFileFromURL()
            return
        }
        
        if isPlayingAudio {
            player?.stop()
            self.isPlayingAudio = false
        } else {
            player?.play()
            self.isPlayingAudio = true
        }
    }
}

extension SongsCollectionViewCell: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            self.player?.stop()
            self.isPlayingAudio = false
        }
    }
}
