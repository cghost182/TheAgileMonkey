//
//  VideoManager.swift
//  TheAgileMonkey
//
//  Created by Christian  Collazos Castañeda on 22/01/21.
//

import Foundation
import AVKit

class VideoManager: NSObject {
    
    static var shared = VideoManager()
    var player: AVPlayer?
    
    private override init() {
    }
    
    func playVideoURL(_ urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            return
        }
        
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player
        
        if let rootViewController = UIApplication.shared.windows.first!.rootViewController {
            rootViewController.present(vc, animated: true) {
                vc.player?.play()
            }
        }
    }
}
