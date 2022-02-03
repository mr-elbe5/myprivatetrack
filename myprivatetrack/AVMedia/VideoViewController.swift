//
//  VideoViewController.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class VideoViewController: ModalViewController {
    
    var videoURL : URL? = nil
    
    var videoView = VideoPlayerView()
    
    override func loadView() {
        super.loadView()
        if let url = videoURL{
            mainView.addSubview(videoView)
            videoView.url = url
            videoView.fillView(view: mainView)
            videoView.setAspectRatioConstraint()
        }
    }
    
}
