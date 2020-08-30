//
//  EditEntryViewController.swift
//
//  Created by Michael Rönnau on 21.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol SaveEntryDelegate{
    func saveEntry(entry: EntryData)
}

class EditEntryViewController: EditViewController, ImageCaptureDelegate, VideoCaptureDelegate, LocationCaptureDelegate, DeleteEntryActionDelegate, SwitchDelegate{
    
    var delegate : SaveEntryDelegate? = nil
    
    var entry : EntryData!
    
    var addTextButton = IconButton(icon: "text.bubble")
    var addImageButton = IconButton(icon: "camera")
    var addAudioButton = IconButton(icon: "mic")
    let addVideoButton = IconButton(icon: "video")
    var addLocationButton = IconButton(icon: "map")
    
    override func loadView() {
        super.loadView()
        let saveLocationSwitch = SwitchView()
        saveLocationSwitch.setupView(labelText: "saveLocation".localize(), isOn: entry.saveLocation)
        saveLocationSwitch.delegate = self
        stackView.addArrangedSubview(saveLocationSwitch)
        for item in entry.items{
            var editItem : EntryItemEditView? = nil
            switch item.type{
            case .text:
                editItem = TextItemEditView.fromData(data: item.data as! TextData)
                break
            case .audio:
                editItem = AudioItemEditView.fromData(data: item.data as! AudioData)
                break
            case .image:
                editItem = ImageItemEditView.fromData(data: item.data as! ImageData)
                break
            case .video:
                editItem = VideoItemEditView.fromData(data: item.data as! VideoData)
                break
            case .location:
                editItem = LocationItemEditView.fromData(data: item.data as! LocationData)
                break
            }
            if let editItem = editItem{
                stackView.addArrangedSubview(editItem)
            }
        }
        let buttonContainer = RightHorizonalControlView()
        buttonContainer.setupView()
        let saveButton = TextButton(text: "save".localize())
        saveButton.addTarget(self, action: #selector(save), for: .touchDown)
        buttonContainer.stackView.addArrangedSubview(saveButton)
        let cancelButton = TextButton(text: "cancel".localize())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        buttonContainer.stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(buttonContainer)
        
    }
    
    override func setupHeaderView(){
        let headerView = UIView()
        let leftStackView = UIStackView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(leftStackView)
        headerView.addSubview(rightStackView)
        leftStackView.setupHorizontal(spacing: 2*defaultInset)
        leftStackView.placeAfter(anchor: headerView.leadingAnchor, padding: defaultInsets)
        rightStackView.setupHorizontal(spacing: 2*defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, padding: defaultInsets)
        
        let addLabel = UILabel()
        addLabel.text = "+"
        addLabel.textColor = UIColor.label
        addLabel.scaleBy(1.25)
        leftStackView.addArrangedSubview(addLabel)
        addTextButton.addTarget(self, action: #selector(addText), for: .touchDown)
        leftStackView.addArrangedSubview(addTextButton)
        addImageButton.addTarget(self, action: #selector(addImage), for: .touchDown)
        leftStackView.addArrangedSubview(addImageButton)
        addAudioButton.addTarget(self, action: #selector(addAudio), for: .touchDown)
        leftStackView.addArrangedSubview(addAudioButton)
        addVideoButton.addTarget(self, action: #selector(addVideo), for: .touchDown)
        leftStackView.addArrangedSubview(addVideoButton)
        addLocationButton.addTarget(self, action: #selector(addLocation), for: .touchDown)
        leftStackView.addArrangedSubview(addLocationButton)
        addLocationButton.isEnabled = Settings.shared.useLocation
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        
        self.headerView = headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addImageButton.isEnabled = Authorization.isCameraAuthorized()
        addAudioButton.isEnabled = Authorization.isAudioAuthorized()
        addVideoButton.isEnabled = Authorization.isCameraAuthorized() && Authorization.isAudioAuthorized()
        addLocationButton.isEnabled = Settings.shared.useLocation && Authorization.isLocationAuthorized()
    }
    
    func switchValueDidChange(sender: SwitchView, isOn: Bool) {
        entry.saveLocation = isOn
        print("state= \(entry.saveLocation)")
    }
    
    @objc func addText(){
        let data = TextData()
        entry.addItem(item: data)
        let editView = TextItemEditView.fromData(data: data)
        insertItemView(editView)
    }
    
    @objc func addImage(){
        if Authorization.isCameraAuthorized(){
            let data = ImageData()
            let imageCaptureController = ImageCaptureViewController()
            imageCaptureController.data = data
            imageCaptureController.delegate = self
            imageCaptureController.modalPresentationStyle = .fullScreen
            self.present(imageCaptureController, animated: true)
        }
        else{
            showError("cameraNotAuthorized")
        }
    }
    
    @objc func addAudio(){
        if Authorization.isAudioAuthorized(){
            let data = AudioData()
            entry.addItem(item: data)
            let editView = AudioItemEditView.fromData(data: data)
            insertItemView(editView)
        }
        else{
            showError("audioNotAuthorized")
        }
    }
    
    @objc func addVideo(){
        if Authorization.isAudioAuthorized() && Authorization.isCameraAuthorized(){
            let data = VideoData()
            let videoCaptureController = VideoCaptureViewController()
            videoCaptureController.data = data
            videoCaptureController.delegate = self
            videoCaptureController.modalPresentationStyle = .fullScreen
            self.present(videoCaptureController, animated: true)
        }
        else{
            showError("videoNotAuthorized")
        }
    }
    
    @objc func addLocation(){
        if Settings.shared.useLocation &&  Authorization.isLocationAuthorized(), let loc = entry.location{
            LocationService.shared.assertRunning()
            let data = LocationData()
            let locationCaptureController = LocationCaptureViewController()
            locationCaptureController.data = data
            locationCaptureController.coordinate = loc.coordinate
            locationCaptureController.delegate = self
            locationCaptureController.modalPresentationStyle = .fullScreen
            self.present(locationCaptureController, animated: true)
        }
        else{
            showError("locationNotAuthorized")
        }
    }
    
    @objc func showInfo(){
        let infoController = EditEntryInfoViewController()
        self.present(infoController, animated: true)
    }
    
    func insertItemView(_ editView: EntryItemEditView){
        editView.delegate = self
        stackView.insertArrangedSubview(editView, at: stackView.arrangedSubviews.count-1)
        scrollView.setNeedsLayout()
        editView.setFocus()
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
    // ImageCaptureDelegate
    
    func imageCaptured(data: ImageData){
        entry.addItem(item: data)
        let editView = ImageItemEditView.fromData(data: data)
        insertItemView(editView)
    }
    
    // VideoCaptureDelegate
    
    func videoCaptured(data: VideoData){
        entry.addItem(item: data)
        let editView = VideoItemEditView.fromData(data: data)
        insertItemView(editView)
    }
    
    // LocationCaptureDelegate
    
    func locationCaptured(data: LocationData){
        entry.addItem(item: data)
        let editView = LocationItemEditView.fromData(data: data)
        insertItemView(editView)
    }
    
    // DeleteEntryActionDelegate
    
    func deleteItem(itemView: EntryItemEditView) {
        for v in stackView.arrangedSubviews{
            if v == itemView {
                entry.removeItem(item: itemView.data)
                stackView.removeArrangedSubview(itemView)
                stackView.removeSubview(itemView)
                break
            }
        }
        
    }
    
    // SaveActionDelegate
    
    @objc func save(){
        if entry.items.count == 0{
            showAlert(title: "error".localize(), text: "noItems".localize())
            return
        }
        if (!entry.isComplete()){
            showAlert(title: "error".localize(), text: "notComplete".localize())
            return
        }
        if let delegate = delegate{
            delegate.saveEntry(entry: entry)
        }
        self.dismiss(animated: true)
    }
    
    @objc func cancel(){
        if entry.isNew{
            entry.removeAllItems()
        }
        self.dismiss(animated: true)
    }
    
    
}

