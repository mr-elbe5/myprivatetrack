//
//  TextItemView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class TextItemView : EntryItemView{
    
    static func fromData(data : TextData)  -> TextItemView{
        let itemView = TextItemView()
        itemView.setupView(data: data)
        return itemView
    }
    
    var textData : TextData? = nil
    var textView = UILabel()
    
    
    func setupView(data: TextData){
        textView.numberOfLines = 0
        addSubview(textView)
        self.textData = data
        textView.text = data.text
        textView.placeBelow(anchor: topAnchor)
        textView.connectBottom(view: self)
    }
    
}

class TextItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : TextData)  -> TextItemEditView{
        let editView = TextItemEditView()
        editView.setupSubviews()
        editView.setupData(data: data, placeholder: "yourText".localize())
        editView.setLayoutConstraints()
        return editView
    }
    
    var textData : TextData!
    
    override var data: EntryItemData{
        get{
            return textData
        }
    }
    
    var textView = ResizingTextView()
    
    override func setupSubviews(){
        addTopControl()
        textView.setDefaults()
        textView.isScrollEnabled = false
        textView.delegate = self
        addSubview(textView)
    }
    
    func setupData(data: TextData, placeholder: String? = nil){
        self.textData = data
        textView.setText(data.text)
        textView.placeholder = placeholder
    }
    
    override func setLayoutConstraints(){
        textView.placeBelow(anchor: deleteButton.bottomAnchor, padding: flatInsets)
        textView.connectBottom(view: self)
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        if textData != nil{
            textData!.text = textView.text!.trim()
        }
        (textView as! ResizingTextView).textDidChange()
    }

}

