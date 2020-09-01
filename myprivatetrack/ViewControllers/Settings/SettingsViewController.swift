//
//  SettingsViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import Zip

enum SettingsPickerType{
    case backup
}

class SettingsViewController: EditViewController, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var backgroundButton = TextButton(text: "selectBackground".localize())
    var resetButton = TextButton(text: "deleteData".localize())
    var exportButton = TextButton(text: "backupData".localize())
    var passwordField = TextEditLine()
    var importButton = TextButton(text: "restoreData".localize())
    
    var pickerType : SettingsPickerType? = nil
    
    override func loadView() {
        super.loadView()
        let header = InfoHeader(text: "settings".localize())
        stackView.addArrangedSubview(header)
        backgroundButton.addTarget(self, action: #selector(selectBackground), for: .touchDown)
        resetButton.addTarget(self, action: #selector(resetData), for: .touchDown)
        passwordField.setupView(labelText: "backupPassword".localize(), text: "", secure: true)
        exportButton.addTarget(self, action: #selector(exportData), for: .touchDown)
        importButton.addTarget(self, action: #selector(importData), for: .touchDown)
        stackView.addArrangedSubview(backgroundButton)
        stackView.addArrangedSubview(resetButton)
        stackView.addArrangedSubview(passwordField)
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
            Settings.shared.backgroundURL = nil
            MainTabController.getTimelineViewController()?.updateBackground()
        })
        alertController.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel) { action in
        })
        self.present(alertController, animated: true)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let imageURL = info[.imageURL] as? URL else {return}
        Settings.shared.backgroundURL = imageURL
        MainTabController.getTimelineViewController()?.updateBackground()
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
    
    @objc func exportData(){
        let exportViewController = BackupViewController()
        exportViewController.password = passwordField.text!.isEmpty ? nil : passwordField.text
        exportViewController.modalPresentationStyle = .fullScreen
        self.present(exportViewController, animated: true)
    }
    
    @objc func importData(){
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
                let password = passwordField.text!.isEmpty ? nil : passwordField.text
                FileStore.deleteAllFiles(dirURL: FileStore.temporaryURL)
                do {
                    try Zip.unzipFile(zipURL, destination: FileStore.temporaryURL, overwrite: true, password: password)
                    let data = GlobalData.readFromTemporaryFile()
                    let fileNames = FileStore.listAllFiles(dirPath: FileStore.temporaryPath)
                    let importViewController = RestoreViewController()
                    importViewController.data = data
                    importViewController.fileNames = fileNames
                    importViewController.modalPresentationStyle = .fullScreen
                    self.present(importViewController, animated: true)
                }
                catch {
                    print("Could not expand zip file")
                    showAlert(title: "error".localize(), text: "fileOpenError".localize())
                }
            }
        }
    }
    
}

