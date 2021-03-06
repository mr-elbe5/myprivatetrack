//
//  EditEntryViewController.swift
//
//  Created by Michael Rönnau on 21.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreLocation
import SwiftyIOSViewExtensions

protocol SaveEntryDelegate{
    func saveEntry(entry: EntryData)
}

class EditEntryViewController: EditViewController, PhotoCaptureDelegate, VideoCaptureDelegate, MapCaptureDelegate, DeleteEntryActionDelegate, SwitchDelegate{
    
    var delegate : SaveEntryDelegate? = nil
    
    var entry : EntryData!
    
    var saveLocationSwitch = SwitchView()
    var addTextButton = IconButton(image: "text-entry")
    var addPhotoButton = IconButton(image: "photo-entry")
    var addAudioButton = IconButton(image: "audio-entry")
    let addVideoButton = IconButton(image: "video-entry")
    
    let mapItemPos = 1
    var addMapSectionButton = TextButton(text: "addMapSection".localize())
    var mapView : MapItemEditView? = nil
    
    override func loadView() {
        super.loadView()
        
        saveLocationSwitch.setEnabled(entry.isNew)
        saveLocationSwitch.setupView(labelText: "saveLocation".localize(), isOn: entry.saveLocation)
        saveLocationSwitch.delegate = self
        
        stackView.addArrangedSubview(saveLocationSwitch)
        addMapSectionButton.addTarget(self, action: #selector(addMapSection), for: .touchDown)
        if entry.saveLocation{
            if entry.hasMapSection{
                mapView = MapItemEditView.fromData(data: entry)
                stackView.insertArrangedSubview(mapView!, at:mapItemPos)
            }
            else if entry.isNew{
                stackView.insertArrangedSubview(addMapSectionButton, at: mapItemPos)
            }
        }
        for item in entry.items{
            var editItem : EntryItemEditView? = nil
            switch item.type{
            case .text:
                editItem = TextItemEditView.fromData(data: item.data as! TextData)
                editItem?.delegate = self
                break
            case .audio:
                editItem = AudioItemEditView.fromData(data: item.data as! AudioData)
                editItem?.delegate = self
                break
            case .photo:
                editItem = PhotoItemEditView.fromData(data: item.data as! PhotoData)
                editItem?.delegate = self
                break
            case .video:
                editItem = VideoItemEditView.fromData(data: item.data as! VideoData)
                editItem?.delegate = self
                break
            }
            if let editItem = editItem{
                stackView.addArrangedSubview(editItem)
            }
        }
        let buttonContainer = ButtonStackView()
        buttonContainer.setupView()
        let saveButton = TextButton(text: (entry.isNew ? "save" : "ok").localize())
        saveButton.addTarget(self, action: #selector(save), for: .touchDown)
        buttonContainer.stackView.addArrangedSubview(saveButton)
        if entry.isNew{
            let cancelButton = TextButton(text: "cancel".localize())
            cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
            buttonContainer.stackView.addArrangedSubview(cancelButton)
        }
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
        leftStackView.placeAfter(anchor: headerView.leadingAnchor, insets: defaultInsets)
        rightStackView.setupHorizontal(spacing: 2*defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, insets: defaultInsets)
        
        addTextButton.addTarget(self, action: #selector(addText), for: .touchDown)
        leftStackView.addArrangedSubview(addTextButton)
        addPhotoButton.addTarget(self, action: #selector(addImage), for: .touchDown)
        leftStackView.addArrangedSubview(addPhotoButton)
        addAudioButton.addTarget(self, action: #selector(addAudio), for: .touchDown)
        leftStackView.addArrangedSubview(addAudioButton)
        addVideoButton.addTarget(self, action: #selector(addVideo), for: .touchDown)
        leftStackView.addArrangedSubview(addVideoButton)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        
        self.headerView = headerView
    }
    
    func switchValueDidChange(sender: SwitchView, isOn: Bool) {
        entry.saveLocation = isOn
        Settings.shared.saveLocation = isOn
        Settings.shared.save()
        if isOn{
            if entry.hasMapSection{
                mapView = MapItemEditView.fromData(data: entry)
                stackView.insertArrangedSubview(mapView!, at:mapItemPos)
            }
            else{
                stackView.insertArrangedSubview(addMapSectionButton, at: mapItemPos)
            }
        }
        else{
            stackView.removeArrangedSubview(addMapSectionButton)
            stackView.removeSubview(addMapSectionButton)
            if mapView != nil{
                stackView.removeArrangedSubview(mapView!)
                stackView.removeSubview(mapView!)
                mapView = nil
            }
            entry.deleteMapSection()
            entry.hasMapSection = false
        }
    }
    
    @objc func addMapSection(){
        if entry.saveLocation && CLLocationManager.authorized{
            let mapCaptureController = MapCaptureViewController()
            mapCaptureController.data = entry
            mapCaptureController.delegate = self
            mapCaptureController.modalPresentationStyle = .fullScreen
            self.present(mapCaptureController, animated: true)
        }
        else{
            showError("locationNotAuthorized")
        }
    }
    
    @objc func addText(){
        let data = TextData()
        entry.addItem(item: data)
        let editView = TextItemEditView.fromData(data: data)
        insertItemView(editView)
    }
    
    @objc func addImage(){
        AVCaptureDevice.askCameraAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = PhotoData()
                    let imageCaptureController = PhotoCaptureViewController()
                    imageCaptureController.data = data
                    imageCaptureController.delegate = self
                    imageCaptureController.modalPresentationStyle = .fullScreen
                    self.present(imageCaptureController, animated: true)
                }
                return
            case .failure:
                DispatchQueue.main.async {
                    self.showError("cameraNotAuthorized")
                }
                return
            }
        }
        
    }
    
    @objc func addAudio(){
        AVCaptureDevice.askAudioAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = AudioData()
                    self.entry.addItem(item: data)
                    let editView = AudioItemEditView.fromData(data: data)
                    self.insertItemView(editView)
                }
                return
            case .failure:
                DispatchQueue.main.async {
                    self.showError("audioNotAuthorized")
                }
                return
            }
        }
    }
    
    @objc func addVideo(){
        AVCaptureDevice.askVideoAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = VideoData()
                    let videoCaptureController = VideoCaptureViewController()
                    videoCaptureController.data = data
                    videoCaptureController.delegate = self
                    videoCaptureController.modalPresentationStyle = .fullScreen
                    self.present(videoCaptureController, animated: true)
                }
                return
            case .failure:
                DispatchQueue.main.async {
                    self.showError("videoNotAuthorized")
                }
                return
            }
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
    
    func photoCaptured(data: PhotoData){
        entry.addItem(item: data)
        let editView = PhotoItemEditView.fromData(data: data)
        insertItemView(editView)
    }
    
    // VideoCaptureDelegate
    
    func videoCaptured(data: VideoData){
        entry.addItem(item: data)
        let editView = VideoItemEditView.fromData(data: data)
        insertItemView(editView)
    }
    
    // MapCaptureDelegate
    
    func mapCaptured(data: EntryData){
        stackView.removeArrangedSubview(addMapSectionButton)
        stackView.removeSubview(addMapSectionButton)
        mapView = MapItemEditView.fromData(data: entry)
        stackView.insertArrangedSubview(mapView!, at: mapItemPos)
        scrollView.setNeedsLayout()
    }
    
    // DeleteEntryActionDelegate
    
    func deleteItem(itemView: EntryItemEditView) {
        showApprove(title: "reallyDeleteItem".localize(), text: "deleteItemApproveInfo".localize()){
            for v in self.stackView.arrangedSubviews{
                if v == itemView {
                    self.entry.removeItem(item: itemView.data)
                    self.stackView.removeArrangedSubview(itemView)
                    self.stackView.removeSubview(itemView)
                    break
                }
            }
        }
    }
    
    // SaveActionDelegate
    
    @objc func save(){
        if !entry.saveLocation && entry.items.count == 0{
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

