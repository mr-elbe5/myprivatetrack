/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class TextItemView : EntryItemView{
    
    static func fromData(data : TextItemData)  -> TextItemView{
        let itemView = TextItemView()
        itemView.setupView(data: data)
        return itemView
    }
    
    var textData : TextItemData? = nil
    var textView = UILabel()
    
    
    func setupView(data: TextItemData){
        textView.numberOfLines = 0
        addSubview(textView)
        self.textData = data
        textView.text = data.text
        textView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
    }
    
}

class TextItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : TextItemData)  -> TextItemEditView{
        let editView = TextItemEditView()
        editView.setupView(data: data, placeholder: "yourText".localize())
        return editView
    }
    
    var textData : TextItemData!
    
    override var data: EntryItemData{
        get{
            return textData
        }
    }
    
    var textView = TextEditArea()
    
    private func setupView(data: TextItemData, placeholder: String){
        self.textData = data
        textView.setText(data.text)
        textView.placeholder = placeholder
        let deleteButton = addDeleteButton()
        textView.setDefaults()
        textView.isScrollEnabled = false
        textView.delegate = self
        addSubview(textView)
        textView.setKeyboardToolbar(doneTitle: "done".localize())
        textView.setAnchors(top: deleteButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: deleteInsets)
    }
    
    @objc func textViewDidChange(_ textView: UITextView) {
        if textData != nil{
            textData!.text = textView.text!.trim()
        }
        (textView as! TextEditArea).textDidChange()
    }

}

