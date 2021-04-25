//
//  AudioPlayerView.swift
//
//  Created by Michael Rönnau on 09.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import SwiftyIOSViewExtensions

class AudioPlayerView : UIView, AVAudioPlayerDelegate{
    
    var player : AVPlayer
    var playerItem : AVPlayerItem? = nil
    
    var playProgress = UIProgressView()
    var rewindButton = IconButton(icon: "repeat")
    var playButton = IconButton(icon: "play.fill")
    
    var timeObserverToken : Any? = nil
    
    private var _url : URL? = nil
    var url : URL?{
        get{
            return _url
        }
        set{
            _url = newValue
            playProgress.setProgress(0, animated: false)
            rewindButton.isEnabled = false
            if _url == nil{
                playButton.isEnabled = false
            } else {
                playButton.isEnabled = true
            }
        }
    }
    
    override init(frame: CGRect) {
        self.player = AVPlayer()
        super.init(frame: frame)
        setRoundedBorders()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(playProgress)
        rewindButton.addTarget(self, action: #selector(rewind), for: .touchDown)
        addSubview(rewindButton)
        playButton.addTarget(self, action: #selector(togglePlay), for: .touchDown)
        addSubview(playButton)
        rewindButton.isEnabled = false
        playButton.isEnabled = false
    }
    
    func layoutView(){
        playProgress.setAnchors()
            .leading(leadingAnchor,inset: Statics.defaultInset)
            .centerY(centerYAnchor)
        playButton.placeBefore(anchor: trailingAnchor)
        rewindButton.placeBefore(view: playButton)
        playProgress.trailing(rewindButton.leadingAnchor, inset: Statics.defaultInset)
    }
    
    func enablePlayer(){
        if url != nil{
            removePeriodicTimeObserver()
            let asset = AVURLAsset(url: url!)
            playerItem = AVPlayerItem(asset: asset)
            player.replaceCurrentItem(with: playerItem!)
            player.rate = 0
            addPeriodicTimeObserver(duration: asset.duration)
            rewindButton.isEnabled = false
        }
    }
    
    func disablePlayer(){
        player.rate = 0
        removePeriodicTimeObserver()
        playerItem = nil
        playProgress.setProgress(0, animated: false)
        rewindButton.isEnabled = false
        playButton.isEnabled = false
    }
    
    func addPeriodicTimeObserver(duration: CMTime) {
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

    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    @objc func rewind(){
        player.rate = 0
        if let item = playerItem{
            item.seek(to: CMTime.zero, completionHandler: nil)
        }
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playProgress.setProgress(0, animated: false)
        rewindButton.isEnabled = false
        playButton.isEnabled = true
    }
    
    @objc func togglePlay(){
        if player.rate == 0{
            print("play")
            player.rate = 1
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            rewindButton.isEnabled = false
        }
        else{
            player.rate = 0
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            rewindButton.isEnabled = true
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero, completionHandler: nil)
            player.rate = 0
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            playButton.isEnabled = false
            rewindButton.isEnabled = true
        }
    }
    
}
