//
//  VideoItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol VideoItemDelegate{
    func viewVideoItem(data: VideoItemData)
    func shareVideoItem(data: VideoItemData)
}

class VideoItemView : EntryItemView{
    
    static func fromData(data : VideoItemData,delegate: VideoItemDelegate? = nil)  -> VideoItemView{
        let itemView = VideoItemView()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    var videoData : VideoItemData? = nil
    
    var delegate : VideoItemDelegate? = nil
    
    var videoView = VideoPlayerView()
    
    func setupView(data: VideoItemData){
        addSubview(videoView)
        self.videoData = data
        videoView.url = data.fileURL
        videoView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        videoView.setAspectRatioConstraint()
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.setAnchors(top: videoView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        }
        else{
            videoView.bottom(bottomAnchor)
        }
        if delegate != nil{
            let sv = UIStackView()
            sv.setupHorizontal(distribution: .fillEqually, spacing: 2*defaultInset)
            addSubview(sv)
            sv.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: doubleInsets)
            let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue, backgroundColor: transparentColor)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            sv.addArrangedSubview(viewButton)
            let shareButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue, backgroundColor: transparentColor)
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
    
    static func fromData(data : VideoItemData)  -> VideoItemEditView{
        let editView = VideoItemEditView()
        editView.setupView(data: data)
        return editView
    }
    
    var videoData : VideoItemData!
    
    var videoView = VideoPlayerView()
    var titleView = TextEditArea()
    
    override var data: EntryItemData{
        get{
            return videoData
        }
    }
    
    private func setupView(data: VideoItemData){
        self.videoData = data
        videoView.url = data.fileURL
        titleView.setText(data.title)
        let deleteButton = addDeleteButton()
        addSubview(videoView)
        titleView.setDefaults(placeholder: "comment".localize())
        titleView.delegate = self
        addSubview(titleView)
        titleView.setKeyboardToolbar(doneTitle: "done".localize())
        videoView.setAnchors(top: deleteButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: deleteInsets)
        videoView.setAspectRatioConstraint()
        titleView.setAnchors(top: videoView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
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
