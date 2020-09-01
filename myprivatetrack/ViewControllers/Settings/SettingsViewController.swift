//
//  SettingsViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

enum SettingsPickerType{
    case backup
}

class SettingsViewController: EditViewController, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var backgroundButton = TextButton(text: "selectBackground".localize())
    var resetButton = TextButton(text: "deleteData".localize())
    var exportButton = TextButton(text: "backupData".localize())
    var importButton = TextButton(text: "restoreData".localize())
    
    var pickerType : SettingsPickerType? = nil
    
    override func loadView() {
        super.loadView()
        let header = InfoHeader(text: "settings".localize())
        stackView.addArrangedSubview(header)
        backgroundButton.addTarget(self, action: #selector(selectBackground), for: .touchDown)
        resetButton.addTarget(self, action: #selector(resetData), for: .touchDown)
        exportButton.addTarget(self, action: #selector(backupData), for: .touchDown)
        importButton.addTarget(self, action: #selector(restoreData), for: .touchDown)
        stackView.addArrangedSubview(backgroundButton)
        stackView.addArrangedSubview(resetButton)
        stackView.addArrangedSubview(exportButton)
        stackView.addArrangedSubview(importButton)
    }
    
    override func setupHeaderView(){
        let headerView = UIView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(rightStackView)
        rightStackView.setupHorizontal(spacing: 2*defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, padding: defaultInsets)
        
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        
        self.headerView = headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        exportButton.isEnabled = globalData.days.count > 0
    }
    
    @objc func showInfo(){
        let infoController = SettingsInfoViewController()
        self.present(infoController, animated: true)
    }
    
    @objc func selectBackground(){
        let alertController = UIAlertController(title: "selectBackground".localize(), message: "backgroundImageInfo".localize(), preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "ownBackground".localize(), style: .default) { action in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .photoLibrary
            pickerController.modalPresentationStyle = .fullScreen
            self.present(pickerController, animated: true, completion: nil)
        })
        alertController.addAction(UIAlertAction(title: "defaultBackground".localize(), style: .default) { action in
            Settings.shared.backgroundName = nil
            Settings.shared.save()
            MainTabController.getTimelineViewController()?.updateBackground()
        })
        alertController.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel) { action in
        })
        self.present(alertController, animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let imageURL = info[.imageURL] as? URL else {return}
        let imageName = "background." + imageURL.pathExtension
        let url = FileStore.getURL(dirURL: FileStore.privateURL, fileName: imageName)
        if FileStore.fileExists(url: url){
            _ = FileStore.deleteFile(url: url)
        }
        if FileStore.copyFile(fromURL: imageURL, toURL: url){
            Settings.shared.backgroundName = imageName
            Settings.shared.save()
            MainTabController.getTimelineViewController()?.updateBackground()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func resetData(){
        showApprove(title: "reallyDelete".localize(), text: "deleteApproveInfo".localize()){
            GlobalData.shared.reset()
            FileStore.deleteAllFiles(dirURL: FileStore.privateURL)
            if let timelineController = MainTabController.getTimelineViewController(){
                timelineController.setNeedsUpdate()
            }
            if let mapController = MainTabController.getMapViewController(){
                mapController.setNeedsUpdate()
            }
        }
        
    }
    
    @objc func backupData(){
        let backupViewController = BackupViewController()
        backupViewController.modalPresentationStyle = .fullScreen
        self.present(backupViewController, animated: true)
    }
    
    @objc func restoreData(){
        let filePicker = UIDocumentPickerViewController(documentTypes: ["com.pkware.zip-archive"], in: .open)
        filePicker.allowsMultipleSelection = false
        filePicker.directoryURL = FileStore.documentURL
        filePicker.delegate = self
        filePicker.modalPresentationStyle = .fullScreen
        self.pickerType = .backup
        self.present(filePicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let type = pickerType{
            switch type{
            case .backup:
                backupPicked(didPickDocumentsAt: urls)
                break
            }
        }
    }
    
    func backupPicked(didPickDocumentsAt urls: [URL]) {
        if let zipURL = urls.first{
            if !FileStore.fileExists(url: zipURL){
                print("no import file")
            }else{
                FileStore.deleteAllFiles(dirURL: FileStore.temporaryURL)
                FileStore.unzipDirectory(zipURL: zipURL, destinationURL: FileStore.temporaryURL)
                let data = GlobalData.readFromTemporaryFile()
                let fileNames = FileStore.listAllFiles(dirPath: FileStore.temporaryPath)
                let importViewController = RestoreViewController()
                importViewController.data = data
                importViewController.fileNames = fileNames
                importViewController.modalPresentationStyle = .fullScreen
                self.present(importViewController, animated: true)
                
            }
        }
    }
    
}

