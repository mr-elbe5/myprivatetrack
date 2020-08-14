//
//  VideoItemView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class VideoItemView : EntryItemView{
    
    static func fromData(data : VideoData)  -> VideoItemView{
        let itemView = VideoItemView()
        itemView.setupView(data: data)
        return itemView
    }
    
    var videoData : VideoData? = nil
    
    var videoView = VideoPlayerView()
    
    func setupView(data: VideoData){
        addSubview(videoView)
        self.videoData = data
        videoView.url = data.fileURL
        videoView.placeBelow(anchor: topAnchor)
        videoView.setAspectRatioConstraint()
        if !data.title.isEmpty{
            let titleView = MediaTitleLabel(text: data.title)
            addSubview(titleView)
            titleView.placeBelow(view: videoView, padding: flatInsets)
            titleView.connectBottom(view: self)
        }
        else{
            videoView.connectBottom(view: self)
        }
    }
    
}

class VideoItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : VideoData)  -> VideoItemEditView{
        let editView = VideoItemEditView()
        editView.setupSubviews()
        editView.setupData(data: data)
        editView.setLayoutConstraints()
        return editView
    }
    
    var videoData : VideoData!
    
    var videoView = VideoPlayerView()
    var titleView = ResizingTextView()
    
    override var data: EntryItemData{
        get{
            return videoData
        }
    }
    
    override func setupSubviews(){
        addTopControl()
        addSubview(videoView)
        titleView.setDefaults(placeholder: "title".localize())
        titleView.delegate = self
        addSubview(titleView)
    }
    
    func setupData(data: VideoData){
        self.videoData = data
        videoView.url = data.fileURL
        titleView.text = data.title
    }
    
    override func setLayoutConstraints(){
        videoView.placeBelow(anchor: deleteButton.bottomAnchor, padding: flatInsets)
        videoView.setAspectRatioConstraint()
        titleView.placeBelow(view: videoView)
        titleView.connectBottom(view: self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if videoData != nil{
            videoData!.title = textView.text!
        }
        titleView.textDidChange()
    }
    
}
