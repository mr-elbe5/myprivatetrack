//
//  TextItemView.swift
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
        textView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
    }
    
}

class TextItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : TextData)  -> TextItemEditView{
        let editView = TextItemEditView()
        editView.setupView(data: data, placeholder: "yourText".localize())
        return editView
    }
    
    var textData : TextData!
    
    override var data: EntryItemData{
        get{
            return textData
        }
    }
    
    var textView = TextEditArea()
    
    private func setupView(data: TextData, placeholder: String){
        self.textData = data
        textView.setText(data.text)
        textView.placeholder = placeholder
        let deleteButton = addDeleteButton()
        textView.setDefaults()
        textView.isScrollEnabled = false
        textView.delegate = self
        addSubview(textView)
        textView.setKeyboardToolbar()
        textView.setAnchors(top: deleteButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: deleteInsets)
    }
    
    override func setFocus(){
        textView.becomeFirstResponder()
        
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        if textData != nil{
            textData!.text = textView.text!.trim()
        }
        (textView as! TextEditArea).textDidChange()
    }

}

