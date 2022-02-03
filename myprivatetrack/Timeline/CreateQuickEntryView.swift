//
//  CreateEntryView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 10.08.21.
//  Copyright © 2021 Michael Rönnau. All rights reserved.
//

import UIKit


protocol CreateQuickEntryDelegate{
    func saveEntry(entry: EntryData)
    func createQuickEntry(text: String)
}

class CreateQuickEntryView: UIView{
    
    var textView = TextEditArea()
    
    var leftStackView = UIStackView()
    
    var rightStackView = UIStackView()
    let saveButton = IconButton(icon: "checkmark.circle", tintColor: .systemGray, backgroundColor: .clear)
    
    var delegate : CreateQuickEntryDelegate? = nil
    
    func setupView(){
        backgroundColor = .clear
        layer.cornerRadius = 5
        textView.setDefaults()
        textView.isScrollEnabled = false
        textView.placeholder = "title/text".localize()
        textView.delegate = self
        addSubview(textView)
        textView.setKeyboardToolbar(doneTitle: "done".localize())
        textView.setAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: .zero)
        
        saveButton.layer.cornerRadius = 15
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        saveButton.addTarget(self, action: #selector(saveEntry), for: .touchDown)
        addSubview(saveButton)
        saveButton.setAnchors(top: topAnchor, leading: textView.trailingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: .zero)
        enableSave(enable: false)
    }
    
    @objc func saveEntry(){
        if !textView.text.isEmpty{
            delegate?.createQuickEntry(text: textView.text)
            reset()
        }
    }
    
    func reset(){
        textView.setText("")
        textView.resignFirstResponder()
        enableSave(enable: false)
    }
    
    private func enableSave(enable: Bool){
        if enable{
            saveButton.tintColor = .systemGreen
            saveButton.isEnabled = true
        }
        else{
            saveButton.tintColor = .systemGray
            saveButton.isEnabled = false
        }
    }
    
}

extension CreateQuickEntryView : SwitchIconDelegate{
    
    func switchValueDidChange(icon: SwitchIcon) {
        Settings.shared.showLocation = icon.isOn
        Settings.shared.save()
    }
    
}

extension CreateQuickEntryView : UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        (textView as! TextEditArea).textDidChange()
        enableSave(enable: !textView.text.isEmpty)
    }
    
}
