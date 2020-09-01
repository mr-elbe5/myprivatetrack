//
//  ExportViewController.swift
//
//  Created by Michael Rönnau on 26.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import Zip

class BackupViewController: ModalScrollViewController, DatePickerDelegate{

    public var stackView = UIStackView()
    
    var startDate : Date!
    var endDate : Date!
    var password: String?
    var startDateView = DatePickerView()
    var endDateView = DatePickerView()
    var backupButton = TextButton(text: "backupData".localize())
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        startDate = GlobalData.shared.firstDayDate
        endDate = GlobalData.shared.lastDayDate
        startDateView.setupView(labelText: "fromDate".localize(), date: startDate, minimumDate: startDate)
        stackView.addArrangedSubview(startDateView)
        endDateView.setupView(labelText: "toDate".localize(), date: endDate, minimumDate: startDate)
        stackView.addArrangedSubview(endDateView)
        backupButton.addTarget(self, action: #selector(backupData), for: .touchDown)
        stackView.addArrangedSubview(backupButton)
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
        let closeButton = IconButton(icon: "xmark.circle")
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        rightStackView.addArrangedSubview(closeButton)
        self.headerView = headerView
    }
    
    @objc func showInfo(){
        let infoController = BackupInfoViewController()
        self.present(infoController, animated: true)
    }
    
    @objc func backupData(){
        let fromString = startDate.dateString().replacingOccurrences(of: ".", with: "-")
        let toString = endDate.dateString().replacingOccurrences(of: ".", with: "-")
        let zipFileName = "backup_" + fromString + "_" + toString + ".zip"
        let data = GlobalData.shared.getCopy(fromDate: startDate, toDate: endDate)
        let fileNames = data.getActiveFileNames()
        var urls = Array<URL>()
        if let dataFileUrl = data.saveAsTemporaryFile(){
            urls.append(dataFileUrl)
        }
        print(fileNames)
        for name in fileNames{
            if FileStore.fileExists(dirPath: FileStore.privatePath, fileName: name){
                urls.append(FileStore.getURL(dirURL: FileStore.privateURL,fileName: name))
            }
            else{
                print("file missing: \(name)")
            }
        }
        let zipURL = FileStore.getURL(dirURL: FileStore.documentURL,fileName: zipFileName)
        do {
            try Zip.zipFiles(paths: urls, zipFilePath: zipURL, password: password, progress: { (progress) -> () in
            })
        }
        catch {
          print("Could not create zip file")
        }
        if FileStore.fileExists(url: zipURL){
            showAlert(title: "success".localize(), text: "backupSuccessInfo".localize()){
                self.dismiss(animated: true)
            }
        }else{
            print("could not create export file")
        }
    }
    
    func dateValueDidChange(sender: DatePickerView, date: Date?) {
        if sender == startDateView{
            startDate = date
        }
        else if sender == endDateView{
            endDate = date
        }
    }
}
