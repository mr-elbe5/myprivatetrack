//
//  VideoPlayerView.swift
//
//  Created by Michael Rönnau on 03.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class VideoPlayerView: UIView {
    
    public var player : AVPlayer
    public var playerLayer : AVPlayerLayer
    public var aspectRatio : CGFloat = 1
    
    public var playButton = UIButton()
    
    public var url : URL? = nil{
        didSet{
            if url != nil{
                let asset = AVURLAsset(url: url!)
                if let track = asset.tracks(withMediaType: AVMediaType.video).first{
                    let size = track.naturalSize.applying(track.preferredTransform)
                    self.aspectRatio = abs(size.width / size.height)
                }
                let item = AVPlayerItem(asset: asset)
                player.replaceCurrentItem(with: item)
                layoutSubviews()
            }
        }
    }
    
    override public init(frame: CGRect) {
        self.player = AVPlayer()
        self.playerLayer = AVPlayerLayer(player: player)
        super.init(frame: frame)
        setRoundedBorders()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.needsDisplayOnBoundsChange = true
        self.layer.addSublayer(playerLayer)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.tintColor = UIColor.white
        playButton.addTarget(self, action: #selector(togglePlay), for: .touchDown)
        addSubview(playButton)
        playButton.setAnchors()
            .centerX(centerXAnchor)
            .bottom(bottomAnchor, inset: Statics.defaultInset)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer.frame = self.bounds
    }
    
    @objc public func togglePlay(){
        if player.rate == 0{
            player.rate = 1
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        else{
            player.rate = 0
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    @objc public func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            player.rate = 0
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        if size.height == UIView.noIntrinsicMetric {
            size.height = size.width / aspectRatio
        }
        return size
    }
    
    public func setAspectRatioConstraint() {
        let c = NSLayoutConstraint(item: self, attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .height,
                                   multiplier: aspectRatio, constant: 0)
        c.priority = UILayoutPriority(900)
        self.addConstraint(c)
    }
    
}

