/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

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
    var volumeView = VolumeSlider()
    
    func setupView(data: VideoItemData){
        addSubview(videoView)
        self.videoData = data
        videoView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        videoView.url = data.fileURL
        videoView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        videoView.setAspectRatioConstraint()
        volumeView.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
        addSubview(volumeView)
        volumeView.setAnchors(top: videoView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.setAnchors(top: volumeView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        }
        else{
            volumeView.bottom(bottomAnchor)
        }
        setupLinks()
    }
    
    func setupLinks(){
        if delegate != nil{
            let sv = UIStackView()
            sv.setupHorizontal(distribution: .fillEqually, spacing: 2*defaultInset)
            addSubview(sv)
            sv.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: doubleInsets)
            let viewButton = IconButton(icon: "magnifyingglass", backgroundColor: transparentColor)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            sv.addArrangedSubview(viewButton)
            let shareButton = IconButton(icon: "square.and.arrow.up", backgroundColor: transparentColor)
            shareButton.addTarget(self, action: #selector(shareItem), for: .touchDown)
            sv.addArrangedSubview(shareButton)
        }
    }
    
    @objc func volumeChanged(){
        videoView.player.volume = volumeView.value
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

class VideoItemPreview: VideoItemView{
    
    static func previewFromData(data : VideoItemData,delegate: VideoItemDelegate? = nil)  -> VideoItemPreview{
        let itemView = VideoItemPreview()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    override func setupView(data: VideoItemData){
        addSubview(videoView)
        self.videoData = data
        videoView.url = data.fileURL
        videoView.fillView(view: self)
        videoView.playerLayer.videoGravity = .resizeAspectFill
        setupLinks()
    }
    
    override func setupLinks(){
        if delegate != nil{
            let viewButton = IconButton(icon: "magnifyingglass", backgroundColor: transparentColor)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            addSubview(viewButton)
            viewButton.setAnchors(top: videoView.topAnchor, trailing: videoView.trailingAnchor, insets: smallInsets)
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
    var volumeView = VolumeSlider()
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
        videoView.setAnchors(top: deleteButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: deleteInsets)
        videoView.setAspectRatioConstraint()
        volumeView.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
        addSubview(volumeView)
        volumeView.setAnchors(top: videoView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        titleView.setDefaults(placeholder: "comment".localize())
        titleView.delegate = self
        addSubview(titleView)
        titleView.setKeyboardToolbar(doneTitle: "done".localize())
        titleView.setAnchors(top: volumeView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
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
    
    @objc func volumeChanged(){
        videoView.player.volume = volumeView.value
    }
    
}
