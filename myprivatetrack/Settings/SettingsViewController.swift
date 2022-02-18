/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

enum SettingsPickerType{
    case backup
}

class SettingsViewController: EditViewController, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SwitchDelegate{
    
    var backgroundButton = TextButton(text: "selectBackground".localize())
    var urlTemplateField = LabeledText()
    var showLocationSwitch = SwitchView()
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
        urlTemplateField.setupView(labelText: "osmTemplate".localize(), text: Settings.shared.osmTemplate, isHorizontal: false)
        
        let elbe5Button = UIButton()
        elbe5Button.setTitle("elbe5TileURL".localize(), for: .normal)
        elbe5Button.setTitleColor(.systemBlue, for: .normal)
        elbe5Button.addTarget(self, action: #selector(elbe5Template), for: .touchDown)
        
        let elbe5InfoLink = UIButton()
        elbe5InfoLink.setTitleColor(.systemBlue, for: .normal)
        elbe5InfoLink.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        elbe5InfoLink.setTitle("elbe5LegalInfo".localize(), for: .normal)
        elbe5InfoLink.addTarget(self, action: #selector(openElbe5Info), for: .touchDown)
        
        let osmButton = UIButton()
        osmButton.setTitle("osmTileURL".localize(), for: .normal)
        osmButton.setTitleColor(.systemBlue, for: .normal)
        osmButton.addTarget(self, action: #selector(osmTemplate), for: .touchDown)
        
        let osmInfoLink = UIButton()
        osmInfoLink.setTitleColor(.systemBlue, for: .normal)
        osmInfoLink.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        osmInfoLink.setTitle("osmLegalInfo".localize(), for: .normal)
        osmInfoLink.addTarget(self, action: #selector(openOSMInfo), for: .touchDown)
        
        let locationHeader = InfoHeader(text: "location".localize())
        showLocationSwitch.setupView(labelText: "showLocation".localize(), isOn: Settings.shared.showLocation)
        showLocationSwitch.delegate = self
        
        let entriesHeader = InfoHeader(text: "entries".localize())
        resetButton.addTarget(self, action: #selector(resetData), for: .touchDown)
        fullBackupButton.addTarget(self, action: #selector(fullBackupData), for: .touchDown)
        partialBackupButton.addTarget(self, action: #selector(partialBackupData), for: .touchDown)
        restoreButton.addTarget(self, action: #selector(restoreData), for: .touchDown)
        removeDocumentsButton.addTarget(self, action: #selector(removeDocuments), for: .touchDown)
        
        stackView.addArrangedSubview(backgroundHeader)
        stackView.addArrangedSubview(backgroundButton)
        stackView.addArrangedSubview(urlTemplateField)
        stackView.addArrangedSubview(elbe5Button)
        stackView.addArrangedSubview(elbe5InfoLink)
        stackView.addArrangedSubview(osmButton)
        stackView.addArrangedSubview(osmInfoLink)
        stackView.addArrangedSubview(locationHeader)
        stackView.addArrangedSubview(showLocationSwitch)
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
        rightStackView.setAnchors(top: headerView.topAnchor, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        self.headerView = headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fullBackupButton.isEnabled = GlobalData.shared.days.count > 0
        partialBackupButton.isEnabled = GlobalData.shared.days.count > 0
    }
    
    @objc func selectBackground(){
        let alertController = UIAlertController(title: "selectBackground".localize(), message: "backgroundImageInfo".localize(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ownBackground".localize(), style: .default) { action in
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.mediaTypes = ["public.image"]
            pickerController.sourceType = .photoLibrary
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
    
    @objc func elbe5Template(){
        urlTemplateField.text = Settings.elbe5Url
        Settings.shared.osmTemplate = Settings.elbe5Url
    }
    
    @objc func openElbe5Info() {
        UIApplication.shared.open(URL(string: "https://privacy.elbe5.de")!)
    }
    
    @objc func osmTemplate(){
        urlTemplateField.text = Settings.osmUrl
        Settings.shared.osmTemplate = Settings.osmUrl
    }
    
    @objc func openOSMInfo() {
        UIApplication.shared.open(URL(string: "https://operations.osmfoundation.org/policies/tiles/")!)
    }
    
    func switchValueDidChange(sender: SwitchView, isOn: Bool) {
        Settings.shared.showLocation = isOn
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

