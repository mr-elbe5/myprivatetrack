/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class BackupViewController: ModalScrollViewController, DatePickerDelegate{

    var stackView = UIStackView()
    
    var startDate : Date? = nil
    var endDate : Date? = nil
    var startDateView = DatePickerView()
    var endDateView = DatePickerView()
    var backupButton = TextButton(text: "backup".localize())
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillView(view: scrollView, insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
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
        rightStackView.setAnchors(top: headerView.topAnchor, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        
        let closeButton = IconButton(icon: "xmark.circle")
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        rightStackView.addArrangedSubview(closeButton)
        self.headerView = headerView
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

