//
//  CreateEntryView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 10.08.21.
//  Copyright © 2021 Michael Rönnau. All rights reserved.
//

import UIKit


protocol CreateEntryDelegate{
    func saveEntry(entry: EntryData)
    func openCreateEntry(entry: EntryData, withItem: EntryItemType)
}

class CreateEntryView: UIView{
    
    var textView = TextEditArea()
    
    var leftStackView = UIStackView()
    var addPhotoButton = IconButton(icon: "camera")
    var addAudioButton = IconButton(icon: "mic")
    let addVideoButton = IconButton(icon: "video")
    var addMapButton = IconButton(icon: "map")
    
    var rightStackView = UIStackView()
    let saveButton = TextButton(text: "save".localize(),tintColor: .white, backgroundColor: .systemGray)
    
    
    var delegate : CreateEntryDelegate? = nil
    
    func setupView(){
        backgroundColor = .white
        layer.cornerRadius = 5
        textView.setDefaults()
        textView.isScrollEnabled = false
        textView.placeholder = "title/text".localize()
        textView.delegate = self
        addSubview(textView)
        textView.setKeyboardToolbar(doneTitle: "done".localize())
        textView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        
        addPhotoButton.addTarget(self, action: #selector(addPhotoEntry), for: .touchDown)
        addSubview(addPhotoButton)
        addPhotoButton.setAnchors(top: textView.bottomAnchor, leading: textView.leadingAnchor, bottom: bottomAnchor, insets: flatInsets)
        addAudioButton.addTarget(self, action: #selector(addAudioEntry), for: .touchDown)
        addSubview(addAudioButton)
        addAudioButton.setAnchors(top: textView.bottomAnchor, leading: addPhotoButton.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        addVideoButton.addTarget(self, action: #selector(addVideoEntry), for: .touchDown)
        addSubview(addVideoButton)
        addVideoButton.setAnchors(top: textView.bottomAnchor, leading: addAudioButton.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        addMapButton.addTarget(self, action: #selector(addMapEntry), for: .touchDown)
        addSubview(addMapButton)
        addMapButton.setAnchors(top: textView.bottomAnchor, leading: addVideoButton.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        saveButton.layer.cornerRadius = 15
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        saveButton.addTarget(self, action: #selector(saveEntry), for: .touchDown)
        addSubview(saveButton)
        saveButton.setAnchors(top: textView.bottomAnchor, trailing: textView.trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
        enableSave(enable: false)
    }
    
    @objc func addPhotoEntry(){
        openCreateEntry(withItem: .photo)
    }
    
    @objc func addAudioEntry(){
        openCreateEntry(withItem: .audio)
    }
    
    @objc func addVideoEntry(){
        openCreateEntry(withItem: .video)
    }
    
    @objc func addMapEntry(){
        openCreateEntry(withItem: .mapphoto)
    }
    
    func openCreateEntry(withItem item: EntryItemType){
        let entry = createEntry()
        delegate?.openCreateEntry(entry: entry, withItem: item)
        reset()
    }
    
    @objc func saveEntry(){
        let entry = createEntry()
        delegate?.saveEntry(entry: entry)
        reset()
    }
    
    private func createEntry() -> EntryData{
        let entry = EntryData(isNew: true)
        entry.location = LocationService.shared.getLocation()
        entry.locationDescription = LocationService.shared.getLocationDescription()
        if !textView.text.isEmpty{
            let entryItem = TextItemData()
            entryItem.text = textView.text
            entry.addItem(item: entryItem)
        }
        return entry
    }
    
    func reset(){
        textView.setText("")
        textView.resignFirstResponder()
        enableSave(enable: false)
    }
    
    private func enableSave(enable: Bool){
        if enable{
            saveButton.backgroundColor = .systemGreen
            saveButton.isEnabled = true
        }
        else{
            saveButton.backgroundColor = .systemGray
            saveButton.isEnabled = false
        }
    }
    
}

extension CreateEntryView : SwitchIconDelegate{
    
    func switchValueDidChange(icon: SwitchIcon) {
        Settings.shared.showLocation = icon.isOn
        Settings.shared.save()
    }
    
}

extension CreateEntryView : UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        (textView as! TextEditArea).textDidChange()
        enableSave(enable: !textView.text.isEmpty)
    }
    
}
