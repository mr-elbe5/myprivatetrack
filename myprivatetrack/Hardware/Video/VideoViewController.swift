//
//  VideoViewController.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public class VideoViewController: ModalViewController {
    
    public var videoURL : URL? = nil
    
    public var videoView = VideoPlayerView()
    
    override public func loadView() {
        super.loadView()
        if let url = videoURL{
            mainView.addSubview(videoView)
            videoView.url = url
            videoView.fillSuperview()
            videoView.setAspectRatioConstraint()
        }
    }
    
}
