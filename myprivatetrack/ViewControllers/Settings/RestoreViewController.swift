//
//  ImportViewController.swift
//
//  Created by Michael Rönnau on 27.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import Zip

class RestoreViewController: ModalScrollViewController, DatePickerDelegate{

    public var stackView = UIStackView()
    
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
        stackView.fillSuperview(padding: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
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
        let infoController = RestoreInfoViewController()
        self.present(infoController, animated: true)
    }
    
    @objc func restoreData(){
        let indicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x - 30, y: self.view.center.y - 30, width: 60, height: 60))
        view.addSubview(indicator)
        indicator.startAnimating()
        //print("start restore")
        for day in data.days{
            //print("check day")
            if day.date < startDate || day.date > endDate{
                //print("discard day")
                continue
            }
            //print("import day")
            restoreDay(day: day)
        }
        GlobalData.shared.sortDays()
        GlobalData.shared.save()
        MainTabController.getTimelineViewController()?.setNeedsUpdate()
        MainTabController.getMapViewController()?.setNeedsUpdate()
        indicator.stopAnimating()
        showAlert(title: "success".localize(), text: "backupRestored".localize()){
            self.dismiss(animated: true)
        }
    }
    
    private func restoreDay(day: DayData){
        var found = false
        for globalDay in GlobalData.shared.days{
            //print("check global day")
            if day.date == globalDay.date{
                //print("day found")
                mergeDay(day: day,globalDay: globalDay)
                found = true
                break
            }
        }
        if !found{
            //print("add day")
            GlobalData.shared.addDay(day: day)
            addFiles(day: day)
        }
    }
    
    private func mergeDay(day: DayData, globalDay: DayData){
        //print("merge day")
        for entry in day.entries{
            //print("check entry")
            var found = false
            for globalEntry in globalDay.entries{
                //print("check global entry")
                if entry.id == globalEntry.id{
                    //print("entry found")
                    found = true
                    break
                }
            }
            if !found{
                //print("add entry")
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
        if entry.hasMapSection{
            if fileNames.contains(entry.mapSectionFileName) && !FileStore.fileExists(url: FileStore.getURL(dirURL: FileStore.privateURL, fileName: entry.mapSectionFileName)){
                _ = FileStore.copyFile(name: entry.mapSectionFileName, fromDir: FileStore.temporaryURL, toDir: FileStore.privateURL)
            }
        }
        for item in entry.items{
            var fnames = Array<String>()
            item.addActiveFileNames(to: &fnames)
            for fname in fnames{
                if fileNames.contains(fname) && !FileStore.fileExists(url: FileStore.getURL(dirURL: FileStore.privateURL, fileName: fname)){
                    _ = FileStore.copyFile(name: fname, fromDir: FileStore.temporaryURL, toDir: FileStore.privateURL)
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

