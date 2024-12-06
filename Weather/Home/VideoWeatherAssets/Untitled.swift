//
//  Untitled.swift
//  Weather
//
//  Created by Taras Pypych on 04.12.2024.
//
//
//import UIKit
//import AVFoundation
//import AVKit
//
//class ViewController: UIViewController {
//
//    let player = AVPlayer()
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//
//        let avView = AVPlayerViewController()
//        self.addChild(avView)
//        self.view.addSubview(avView.view)
//        avView.view.frame = self.view.bounds
//        avView.player = player
//        let bundle = Bundle.main
//        let url = bundle.url(forResource: "cloudy", withExtension: "mp4")!
//        let avItem: AVPlayerItem? = AVPlayerItem(url: url)
//        player.replaceCurrentItem(with: avItem)
//        avView.videoGravity = .resizeAspectFill
//        player.play()
//    }
//
//
//}
