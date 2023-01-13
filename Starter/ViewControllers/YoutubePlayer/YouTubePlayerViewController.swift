//
//  YouTubePlayerViewController.swift
//  Starter
//
//  Created by Ye Lynn Htet on 21/03/2022.
//

import UIKit
import YouTubePlayer

class YouTubePlayerViewController: UIViewController {
    
    @IBOutlet var videoPlayer: YouTubePlayerView!
    
    var youtubeId: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load video from YouTube ID
        if let id = youtubeId {
            videoPlayer.loadVideoID(id)
            videoPlayer.play()
        } else {
            //Invalid youtube id
            print("Invalid YouTubeID.")
        }
        
    }
    
    @IBAction func onClickDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }


}
