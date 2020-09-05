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
    func shareVideoItem(data: VideoData)
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
            let sv = UIStackView()
            sv.setupHorizontal(distribution: .fillEqually, spacing: 2*defaultInset)
            addSubview(sv)
            sv.placeTopRight(padding: doubleInsets)
            let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue, backgroundColor: .systemBackground)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            sv.addArrangedSubview(viewButton)
            let shareButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue, backgroundColor: .systemBackground)
            shareButton.addTarget(self, action: #selector(shareItem), for: .touchDown)
            sv.addArrangedSubview(shareButton)
        }
    }
    
    @objc func viewItem(){
        if let videoData = videoData{
            delegate?.viewVideoItem(data: videoData)
        }
    }
    
    @objc func shareItem(){
        if let videoData = videoData{
            delegate?.shareVideoItem(data: videoData)
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
    var titleView = TextEditArea()
    
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
        titleView.setKeyboardToolbar()
    }
    
    func setupData(data: VideoData){
        self.videoData = data
        videoView.url = data.fileURL
        titleView.text = data.title
    }
    
    override func setLayoutConstraints(){
        videoView.placeBelow(anchor: deleteButton.bottomAnchor, padding: deleteInsets)
        videoView.setAspectRatioConstraint()
        titleView.placeBelow(view: videoView)
        titleView.connectBottom(view: self)
    }
    
    override func setFocus(){
        titleView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if videoData != nil{
            videoData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
