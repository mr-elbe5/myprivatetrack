//
//  AudioItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class AudioItemView : EntryItemView, AVAudioPlayerDelegate{
    
    static func fromData(data : AudioData)  -> AudioItemView{
        let itemView = AudioItemView()
        itemView.setupView(data: data)
        return itemView
    }
    
    var audioData : AudioData!
    
    var audioView = AudioPlayerView()
    
    func setupView(data: AudioData){
        audioView.setRoundedBorders()
        addSubview(audioView)
        
        self.audioData = data
        audioView.url = data.fileURL
        audioView.enablePlayer()
        audioView.placeBelow(anchor: topAnchor)
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.placeBelow(view: audioView, padding: flatInsets)
            titleView.connectBottom(view: self)
        }
        else{
            audioView.connectBottom(view: self)
        }
    }
    
}

class AudioItemEditView : EntryItemEditView, UITextViewDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    static func fromData(data : AudioData)  -> AudioItemEditView{
        let editView = AudioItemEditView()
        editView.setupSubviews()
        editView.setupData(data: data)
        editView.setLayoutConstraints()
        return editView
    }
    
    var audioData : AudioData!
    
    var audioView = AudioRecorderView()
    var titleView = ResizingTextView()
    
    override var data: EntryItemData{
        get{
            return audioData
        }
    }
    
    override func setupSubviews(){
        addTopControl()
        audioView.setRoundedBorders()
        addSubview(audioView)
        titleView.setDefaults(placeholder: "comment".localize())
        titleView.delegate = self
        addSubview(titleView)
    }
    
    func setupData(data: AudioData){
        self.audioData = data
        audioView.url = data.fileURL
        audioView.enableRecording()
        if audioData.fileExists(){
            audioView.enablePlayer()
        }
        titleView.text = data.title
    }
    
    override func setLayoutConstraints(){
        audioView.placeBelow(anchor: deleteButton.bottomAnchor, padding: flatInsets)
        titleView.placeBelow(view: audioView)
        titleView.connectBottom(view: self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if audioData != nil{
            audioData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
