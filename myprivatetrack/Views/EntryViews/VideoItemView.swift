//
//  VideoItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol VideoItemDelegate{
    func viewVideoItem(data: VideoData)
}

class VideoItemView : EntryItemView{
    
    static func fromData(data : VideoData,delegate: VideoItemDelegate? = nil)  -> VideoItemView{
        let itemView = VideoItemView()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    var videoData : VideoData? = nil
    
    var delegate : VideoItemDelegate? = nil
    
    var videoView = VideoPlayerView()
    
    func setupView(data: VideoData){
        addSubview(videoView)
        self.videoData = data
        videoView.url = data.fileURL
        videoView.placeBelow(anchor: topAnchor)
        videoView.setAspectRatioConstraint()
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.placeBelow(view: videoView, padding: flatInsets)
            titleView.connectBottom(view: self)
        }
        else{
            videoView.connectBottom(view: self)
        }
        if delegate != nil{
            let viewButton = ViewDetailButton(withBackground: true)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            addSubview(viewButton)
            viewButton.placeTopRight(padding: doubleInsets)
        }
    }
    
    @objc func viewItem(){
        if let videoData = videoData{
            delegate?.viewVideoItem(data: videoData)
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
        titleView.setDefaults(placeholder: "comment".localize())
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
            videoData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
