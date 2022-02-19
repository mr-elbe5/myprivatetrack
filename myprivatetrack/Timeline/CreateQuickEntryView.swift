/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

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
        textView.placeholder = "yourText".localize()
        textView.delegate = self
        addSubview(textView)
        textView.setKeyboardToolbar(doneTitle: "done".localize())
        textView.setAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: .zero)
        
        saveButton.layer.cornerRadius = 15
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        saveButton.addTarget(self, action: #selector(saveEntry), for: .touchDown)
        addSubview(saveButton)
        saveButton.setAnchors(leading: textView.trailingAnchor, trailing: trailingAnchor, insets: .zero)
            .height(30)
            .centerY(textView.centerYAnchor)
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
