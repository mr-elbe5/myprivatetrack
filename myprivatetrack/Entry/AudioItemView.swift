/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

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
        audioView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        audioView.layoutView()
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.setAnchors(top: audioView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        }
        else{
            audioView.bottom(bottomAnchor)
        }
    }
    
}

class AudioItemEditView : EntryItemEditView, UITextViewDelegate{
        
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
        audioView.data = data
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
        titleView.setKeyboardToolbar(doneTitle: "done".localize())
        audioView.setAnchors(top: deleteButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: deleteInsets)
        audioView.layoutView()
        titleView.setAnchors(top: audioView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if audioData != nil{
            audioData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
