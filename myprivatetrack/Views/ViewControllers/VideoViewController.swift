//
//  VideoViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class VideoViewController: ModalViewController {
    
    var videoData : VideoData? = nil
    
    var videoView = VideoPlayerView()
    
    override func loadView() {
        super.loadView()
        if let videoData = videoData{
            mainView.addSubview(videoView)
            videoView.url = videoData.fileURL
            videoView.fillSuperview()
            videoView.setAspectRatioConstraint()
        }
    }
    
}
