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
    
    private func setupView(data: AudioData){
        audioView.setRoundedBorders()
        addSubview(audioView)
        audioView.setupView()
        self.audioData = data
        audioView.url = data.fileURL
        audioView.enablePlayer()
        audioView.placeBelow(anchor: topAnchor)
        audioView.layoutView()
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.placeBelow(view: audioView, insets: flatInsets)
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
        editView.setupView(data: data)
        return editView
    }
    
    var audioData : AudioData!
    
    var audioView = AudioRecorderView()
    var titleView = TextEditArea()
    
    override var data: EntryItemData{
        get{
            return audioData
        }
    }
    
    func setupView(data: AudioData){
        self.audioData = data
        audioView.url = data.fileURL
        audioView.enableRecording()
        if audioData.fileExists(){
            audioView.player.enablePlayer()
        }
        titleView.setText(data.title)
        let deleteButton = addDeleteButton()
        audioView.setRoundedBorders()
        addSubview(audioView)
        audioView.setupView()
        titleView.setDefaults(placeholder: "comment".localize())
        titleView.delegate = self
        addSubview(titleView)
        titleView.setKeyboardToolbar()
        audioView.placeBelow(anchor: deleteButton.bottomAnchor, insets: deleteInsets)
        audioView.layoutView()
        titleView.placeBelow(view: audioView)
        titleView.connectBottom(view: self)
    }
    
    override func setFocus(){
        titleView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if audioData != nil{
            audioData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
