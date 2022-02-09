/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import Zip

class RestoreViewController: ModalScrollViewController, DatePickerDelegate{

    var stackView = UIStackView()
    
    var data: GlobalData!
    var fileNames: Array<String>!
    var startDate : Date!
    var endDate : Date!
    var startDateView = DatePickerView()
    var endDateView = DatePickerView()
    var restoreButton = TextButton(text: "restoreData".localize())
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillView(view: scrollView, insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        startDate = data.firstDayDate
        endDate = data.lastDayDate
        startDateView.setupView(labelText: "fromDate".localize(), date: startDate, minimumDate: startDate)
        stackView.addArrangedSubview(startDateView)
        endDateView.setupView(labelText: "toDate".localize(), date: endDate, minimumDate: startDate)
        stackView.addArrangedSubview(endDateView)
        restoreButton.addTarget(self, action: #selector(restoreData), for: .touchDown)
        stackView.addArrangedSubview(restoreButton)
    }
    
    override func setupHeaderView(){
        let headerView = UIView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(rightStackView)
        rightStackView.setupHorizontal(spacing: 2*defaultInset)
        rightStackView.setAnchors(top: headerView.topAnchor, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        let closeButton = IconButton(icon: "xmark.circle")
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        rightStackView.addArrangedSubview(closeButton)
        self.headerView = headerView
    }
    
    @objc func showInfo(){
        let infoController = RestoreInfoViewController()
        self.present(infoController, animated: true)
    }
    
    @objc func restoreData(){
        Indicator.shared.show()
        for day in data.days{
            if day.date < startDate || day.date > endDate{
                continue
            }
            restoreDay(day: day)
        }
        GlobalData.shared.sortDays()
        GlobalData.shared.save()
        MainTabController.getTimelineViewController()?.setNeedsUpdate()
        MainTabController.getMapViewController()?.setNeedsUpdate()
        Indicator.shared.hide()
        showAlert(title: "success".localize(), text: "backupRestored".localize()){
            self.dismiss(animated: true)
        }
    }
    
    private func restoreDay(day: DayData){
        var found = false
        for globalDay in GlobalData.shared.days{
            if day.date == globalDay.date{
                mergeDay(day: day,globalDay: globalDay)
                found = true
                break
            }
        }
        if !found{
            GlobalData.shared.addDay(day: day)
            addFiles(day: day)
        }
    }
    
    private func mergeDay(day: DayData, globalDay: DayData){
        for entry in day.entries{
            var found = false
            for globalEntry in globalDay.entries{
                if entry.id == globalEntry.id{
                    found = true
                    break
                }
            }
            if !found{
                globalDay.addEntry(entry: entry)
                addFiles(entry: entry)
                globalDay.sortEntries()
            }
        }
    }
    
    private func addFiles(day: DayData){
        for entry in day.entries{
            addFiles(entry: entry)
        }
    }
    
    private func addFiles(entry: EntryData){
        for item in entry.items{
            var fnames = Array<String>()
            item.addActiveFileNames(to: &fnames)
            for fname in fnames{
                if fileNames.contains(fname) && !FileController.fileExists(url: FileController.getURL(dirURL: FileController.privateURL, fileName: fname)){
                    _ = FileController.copyFile(name: fname, fromDir: FileController.temporaryURL, toDir: FileController.privateURL)
                }
            }
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

