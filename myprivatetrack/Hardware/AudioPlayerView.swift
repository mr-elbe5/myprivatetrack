//
//  AudioPlayerView.swift
//
//  Created by Michael Rönnau on 09.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class AudioPlayerView : UIView, AVAudioPlayerDelegate{
    
    public var player : AVPlayer
    public var playerItem : AVPlayerItem? = nil
    public var playProgress = UIProgressView()
    public var rewindButton = IconButton(icon: "repeat")
    public var playButton = IconButton(icon: "play.fill")
    
    public var timeObserverToken : Any? = nil
    
    public var url : URL? = nil
    
    override public init(frame: CGRect) {
        self.player = AVPlayer()
        super.init(frame: frame)
        setRoundedBorders()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
        setupView()
        layoutView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupView(){
        addSubview(playProgress)
        rewindButton.addTarget(self, action: #selector(rewind), for: .touchDown)
        addSubview(rewindButton)
        playButton.addTarget(self, action: #selector(togglePlay), for: .touchDown)
        addSubview(playButton)
    }
    
    public func layoutView(){
        playProgress.enableAnchors()
        playProgress.setLeadingAnchor(leadingAnchor,padding: Statics.defaultInset)
        playProgress.setCenterYAnchor(centerYAnchor)
        playButton.placeBefore(anchor: trailingAnchor)
        rewindButton.placeBefore(view: playButton)
        playProgress.setTrailingAnchor(rewindButton.leadingAnchor, padding: Statics.defaultInset)
    }
    
    public func enablePlayer(){
        if url != nil{
            removePeriodicTimeObserver()
            let asset = AVURLAsset(url: url!)
            playerItem = AVPlayerItem(asset: asset)
            player.replaceCurrentItem(with: playerItem!)
            player.rate = 0
            addPeriodicTimeObserver(duration: asset.duration)
        }
    }
    
    public func disablePlayer(){
        player.rate = 0
        removePeriodicTimeObserver()
        playerItem = nil
    }
    
    public func addPeriodicTimeObserver(duration: CMTime) {
        let seconds = Float(CMTimeGetSeconds(duration))
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
                                                           queue: .main) {
                                                            [weak self] time in
                                                            let part = Float(CMTimeGetSeconds(time))
                                                            self?.playProgress.setProgress(part/seconds, animated: true)
        }
    }

    public func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    @objc public func rewind(){
        player.rate = 0
        if let item = playerItem{
            item.seek(to: CMTime.zero, completionHandler: nil)
        }
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
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
    
}
