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
    var volumeView = VolumeSlider()
    
    override func loadView() {
        super.loadView()
        if let url = videoURL{
            mainView.addSubview(videoView)
            videoView.url = url
            videoView.setAnchors(top: mainView.topAnchor, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor)
            volumeView.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
            mainView.addSubview(volumeView)
            volumeView.setAnchors(top: videoView.bottomAnchor, leading: mainView.leadingAnchor, trailing: mainView.trailingAnchor, bottom: mainView.bottomAnchor, insets: defaultInsets)
                .sliderHeight()
            videoView.setAspectRatioConstraint()
        }
    }
    
    @objc func volumeChanged(){
        videoView.player.volume = volumeView.value
    }
    
}
