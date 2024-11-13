//
//  VideoBackgroundView.swift
//  Weather
//
//  Created by Taras Pypych on 2024-11-13.
//

import UIKit
import AVFoundation

class VideoBackgroundView: UIView {
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    init(videoName: String, fileType: String = "mp4") {
        super.init(frame: .zero)
        setupVideo(videoName: videoName, fileType: fileType)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupVideo(videoName: String, fileType: String) {
        guard let path = Bundle.main.path(forResource: videoName, ofType: fileType) else {
            print("Video file not found.")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        
        if let playerLayer = playerLayer {
            layer.addSublayer(playerLayer)
        }
        
        player?.play()
        player?.actionAtItemEnd = .none
        
        // Повтор видео
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(restartVideo),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    @objc private func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
}
