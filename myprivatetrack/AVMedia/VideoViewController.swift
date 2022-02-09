/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

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
