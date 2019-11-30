//
//  ViewController.swift
//  TheMovieDBApp
//
//  Created by Flavia Arsuffi on 21/11/19.
//  Copyright © 2019 Flavia Arsuffi. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        
        setUpElements()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setUpMedia()
    }
    
    func setUpMedia() {
        
        // Path to resouce
        let  bundlePath = Bundle.main.path(forResource: "TVwatch", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        // Create URL
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Video item
        let item = AVPlayerItem(url: url)
        
        // Player
        videoPlayer = AVPlayer(playerItem: item)
        
        // Layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        // Size and frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*0.7,
                                         y: 80,
                                         width: self.view.frame.size.width*2.5,
                                         height: self.view.frame.size.height)
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        videoPlayer?.playImmediately(atRate: 0.8)
    }
    
    func setUpElements() {
        
        Utilities.styleHollowButton(loginButton)
        Utilities.styleFilledButton(signInButton)
        
    }


}

