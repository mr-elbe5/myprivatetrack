//
//  SettingsViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import Zip

class SettingsViewController: EditViewController, SwitchDelegate, UIDocumentPickerDelegate{

    var useLocationSwitch = SwitchView()
    
    var resetButton = TextButton(text: "deleteData".localize())
    var exportButton = TextButton(text: "backupData".localize())
    var passwordField = TextView()
    var importButton = TextButton(text: "restoreData".localize())
    
    override func loadView() {
        super.loadView()
        let header = InfoHeader(text: "settings".localize())
        stackView.addArrangedSubview(header)
        useLocationSwitch.setupView(labelText: "useLocation".localize(), isOn: settings.useLocation)
        useLocationSwitch.delegate = self
        resetButton.addTarget(self, action: #selector(resetData), for: .touchDown)
        passwordField.setupView(labelText: "backupPassword".localize(), text: "", secure: true)
        exportButton.addTarget(self, action: #selector(exportData), for: .touchDown)
        importButton.addTarget(self, action: #selector(importData), for: .touchDown)
        stackView.addArrangedSubview(useLocationSwitch)
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
        self.present(filePicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
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
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("cancelled")
    }
    
    func switchValueDidChange(sender: SwitchView, isOn: Bool) {
        if sender == useLocationSwitch{
            settings.useLocation = isOn
            if settings.useLocation{
                LocationService.shared.startUpdatingLocation()
            }
            else{
                LocationService.shared.stopUpdatingLocation()
            }
            
        }
        settings.save()
    }
    
}
