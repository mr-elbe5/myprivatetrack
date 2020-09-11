//
//  ExportViewController.swift
//
//  Created by Michael Rönnau on 26.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class BackupViewController: ModalScrollViewController, DatePickerDelegate{

    public var stackView = UIStackView()
    
    var startDate : Date? = nil
    var endDate : Date? = nil
    var startDateView = DatePickerView()
    var endDateView = DatePickerView()
    var backupButton = TextButton(text: "backup".localize())
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillSuperview(insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
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
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, insets: defaultInsets)
        
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
        if let from = startDate, let to = endDate{
            let indicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x - 30, y: self.view.center.y - 30, width: 60, height: 60))
            view.addSubview(indicator)
            indicator.startAnimating()
            let fromString = from.dateString().replacingOccurrences(of: ".", with: "-")
            let toString = to.dateString().replacingOccurrences(of: ".", with: "-")
            let zipFileName = Statics.backupName + fromString + "_" + toString + ".zip"
            let data = GlobalData.shared.getCopy(fromDate: from, toDate: to)
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
            FileController.zipFiles(sourceFiles: urls, zipURL: zipURL)
            indicator.stopAnimating()
            if FileController.fileExists(url: zipURL){
                showAlert(title: "success".localize(), text: "backupSuccessInfo".localize()){
                    self.dismiss(animated: true)
                }
            }else{
                print("could not create export file")
            }
        }
        else{
            print("could not create export file: no data")
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

