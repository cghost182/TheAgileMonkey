//
//  AudioManager.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 21/01/21.
//

import Foundation
import AVFoundation

typealias downloadFileFromURLCallbackType = (_ :Bool) -> Void
class AudioManager: NSObject {
    
    static var shared = AudioManager()
    var player: AVAudioPlayer?
    
    private override init() {
    }
    
    func playSound() {
        NotificationCenter.default.post(name: .audioManagerStopPlaying, object: nil)
        player?.play()
    }
    
    func stopSound() {
        player?.stop()
    }
    
    func playSound(with url: URL, didFinishDownloadingCallback: downloadFileFromURLCallbackType) {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp4.rawValue)

            guard let player = player else {
                didFinishDownloadingCallback(false)
                return
            }

            player.play()
            player.delegate = self
            didFinishDownloadingCallback(true)
        } catch let error {
            didFinishDownloadingCallback(false)
            print(error.localizedDescription)
        }
    }

    func downloadFileFromURL(_ audioURLString: String?, didFinishDownloadingCallback: @escaping downloadFileFromURLCallbackType){
        
        guard let urlString = audioURLString,
              let url = URL(string: urlString) else {
            didFinishDownloadingCallback(false)
            return
        }
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] (url, response, error) in
            
            self?.player?.stop()
            NotificationCenter.default.post(name: .audioManagerStopPlaying, object: nil)
            
            if let url = url {
                self?.playSound(with: url, didFinishDownloadingCallback: didFinishDownloadingCallback)
            } else {
                didFinishDownloadingCallback(false)
            }
        }
        downloadTask.resume()
    }
}

extension AudioManager: AVAudioPlayerDelegate {

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            self.player?.stop()
            NotificationCenter.default.post(name: .audioManagerStopPlaying, object: nil)
        }
    }
}
