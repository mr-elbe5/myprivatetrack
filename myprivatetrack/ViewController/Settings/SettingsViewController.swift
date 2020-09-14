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
    
    static var sizeItems : Array<String> = ["small".localize(),"medium".localize(),"large".localize()]

    var backgroundButton = TextButton(text: "selectBackground".localize())
    var mapStartSizeControl = UISegmentedControl(items: sizeItems)
    var resetButton = TextButton(text: "deleteData".localize())
    var fullBackupButton = TextButton(text: "fullBackupData".localize())
    var partialBackupButton = TextButton(text: "partialBackupData".localize())
    var restoreButton = TextButton(text: "restoreData".localize())
    var removeDocumentsButton = TextButton(text: "deleteDocuments".localize())
    
    var pickerType : SettingsPickerType? = nil
    
    override func loadView() {
        super.loadView()
        let backgroundHeader = InfoHeader(text: "backgroundImage".localize())
        backgroundButton.addTarget(self, action: #selector(selectBackground), for: .touchDown)
        let mapSizeHeader = InfoHeader(text: "mapStartSize".localize())
        mapStartSizeControl.setTitleTextAttributes([.foregroundColor: UIColor.label, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
        mapStartSizeControl.selectedSegmentIndex = Settings.shared.mapStartSizeIndex
        mapStartSizeControl.addTarget(self, action: #selector(toggleMapStartSize), for: .valueChanged)
        let entriesHeader = InfoHeader(text: "entries".localize())
        resetButton.addTarget(self, action: #selector(resetData), for: .touchDown)
        fullBackupButton.addTarget(self, action: #selector(fullBackupData), for: .touchDown)
        partialBackupButton.addTarget(self, action: #selector(partialBackupData), for: .touchDown)
        restoreButton.addTarget(self, action: #selector(restoreData), for: .touchDown)
        removeDocumentsButton.addTarget(self, action: #selector(removeDocuments), for: .touchDown)
        stackView.addArrangedSubview(backgroundHeader)
        stackView.addArrangedSubview(backgroundButton)
        stackView.addArrangedSubview(mapSizeHeader)
        stackView.addArrangedSubview(mapStartSizeControl)
        stackView.addArrangedSubview(entriesHeader)
        stackView.addArrangedSubview(resetButton)
        stackView.addArrangedSubview(fullBackupButton)
        stackView.addArrangedSubview(partialBackupButton)
        stackView.addArrangedSubview(restoreButton)
        let filesHeader = InfoHeader(text: "files".localize())
        stackView.addArrangedSubview(filesHeader)
        stackView.addArrangedSubview(removeDocumentsButton)
    }
    
    override func setupHeaderView(){
        let headerView = UIView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(rightStackView)
        rightStackView.setupHorizontal(spacing: 2*defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, insets: defaultInsets)
        
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        
        self.headerView = headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fullBackupButton.isEnabled = globalData.days.count > 0
        partialBackupButton.isEnabled = globalData.days.count > 0
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let imageURL = info[.imageURL] as? URL else {return}
        let imageName = Statics.backgroundName + imageURL.pathExtension
        let url = FileController.getURL(dirURL: FileController.privateURL, fileName: imageName)
        if FileController.fileExists(url: url){
            _ = FileController.deleteFile(url: url)
        }
        if FileController.copyFile(fromURL: imageURL, toURL: url){
            Settings.shared.backgroundName = imageName
            Settings.shared.save()
            MainTabController.getTimelineViewController()?.updateBackground()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func toggleMapStartSize() {
        let selectedSize = mapStartSizeControl.selectedSegmentIndex
        switch selectedSize {
        case 0 :
            Settings.shared.mapStartSize = .small
            break
        case 1 :
            Settings.shared.mapStartSize = .mid
            break
        case 2 :
            Settings.shared.mapStartSize = .large
            break
        default:
            break
        }
        Settings.shared.save()
    }
    
    @objc func resetData(){
        showApprove(title: "reallyDeleteAllData".localize(), text: "deleteAllDataApproveInfo".localize()){
            GlobalData.shared.reset()
            FileController.deleteAllFiles(dirURL: FileController.privateURL)
            //FileController.printFileInfo()
            if let timelineController = MainTabController.getTimelineViewController(){
                timelineController.setNeedsUpdate()
            }
            if let mapController = MainTabController.getMapViewController(){
                mapController.setNeedsUpdate()
            }
        }
        
    }
    
    @objc func fullBackupData(){
        Indicator.shared.show()
        DispatchQueue.global(qos: .userInitiated).async{
            let zipFileName = Statics.backupOfName + Date().dateString().replacingOccurrences(of: ".", with: "-") + ".zip"
            let data = GlobalData.shared
            let fileNames = data.getActiveFileNames()
            var urls = Array<URL>()
            if let dataFileUrl = data.saveAsTemporaryFile(){
                urls.append(dataFileUrl)
            }
            print(fileNames)
            for name in fileNames{
                if FileController.fileExists(dirPath: FileController.privatePath, fileName: name){
                    urls.append(FileController.getURL(dirURL: FileController.privateURL,fileName: name))
                }
                else{
                    print("file missing: \(name)")
                }
            }
            let zipURL = FileController.getURL(dirURL: FileController.backupDirURL,fileName: zipFileName)
            if FileController.fileExists(url: zipURL){
                _ = FileController.deleteFile(url: zipURL)
            }
            FileController.zipFiles(sourceFiles: urls, zipURL: zipURL)
            DispatchQueue.main.async{
                Indicator.shared.hide()
                if FileController.fileExists(url: zipURL){
                    self.showAlert(title: "success".localize(), text: "backupSuccessInfo".localize()){
                        self.dismiss(animated: true)
                    }
                }else{
                    print("could not create export file")
                }
            }
        }
    }
    
    @objc func partialBackupData(){
        let backupViewController = BackupViewController()
        backupViewController.modalPresentationStyle = .fullScreen
        self.present(backupViewController, animated: true)
    }
    
    @objc func restoreData(){
        let filePicker = UIDocumentPickerViewController(documentTypes: ["com.pkware.zip-archive"], in: .open)
        filePicker.allowsMultipleSelection = false
        filePicker.directoryURL = FileController.backupDirURL
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
            if !FileController.fileExists(url: zipURL){
                print("no import file")
            }else{
                DispatchQueue.main.async{
                    Indicator.shared.show()
                }
                DispatchQueue.global(qos: .userInitiated).async{
                    FileController.deleteAllFiles(dirURL: FileController.temporaryURL)
                    FileController.unzipDirectory(zipURL: zipURL, destinationURL: FileController.temporaryURL)
                    let data = GlobalData.readFromTemporaryFile()
                    //print("data=\(data)")
                    let fileNames = FileController.listAllFiles(dirPath: FileController.temporaryPath)
                    DispatchQueue.main.async{
                        Indicator.shared.hide()
                        let importViewController = RestoreViewController()
                        importViewController.data = data
                        importViewController.fileNames = fileNames
                        importViewController.modalPresentationStyle = .fullScreen
                        self.present(importViewController, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func removeDocuments(){
        showApprove(title: "reallyDeleteDocuments".localize(), text: "deleteDocumentsApproveInfo".localize()){
            FileController.deleteAllFiles(dirURL: FileController.backupDirURL)
            FileController.deleteAllFiles(dirURL: FileController.exportDirURL)
            FileController.deleteAllFiles(dirURL: FileController.temporaryURL)
            //FileController.printFileInfo()
            self.showAlert(title: "success".localize(), text: "documentsDeleted".localize())
        }
    }
    
}

