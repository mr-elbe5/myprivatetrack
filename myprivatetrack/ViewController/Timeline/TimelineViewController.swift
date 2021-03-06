//
//  TimelineViewController.swift
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit
import SwiftyIOSViewExtensions

class TimelineViewController: TableViewController, SaveEntryDelegate, EntryCellActionDelegate{

    private static let CELL_IDENT = "entryCell"
    
    var firstAppearance = true
    
    var backgroundView = UIImageView(image: Settings.shared.backgroundImage)
    
    var addEmptyButton = IconButton(image: "blank-entry")
    var addTextButton = IconButton(image: "text-entry")
    var addPhotoButton = IconButton(image: "photo-entry")
    var addAudioButton = IconButton(image: "audio-entry")
    let addVideoButton = IconButton(image: "video-entry")
    let editButton = IconButton(icon: "pencil.circle")
    
    override func loadView(){
        super.loadView()
        tableView.backgroundColor = UIColor.clear
        backgroundView.contentMode = UIView.ContentMode.scaleAspectFill;
        tableView.backgroundView = backgroundView
        tableView.register(TimelineEntryCell.self, forCellReuseIdentifier: TimelineViewController.CELL_IDENT)
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
    }
    
    override open func setupHeaderView(){
        let headerView = UIView()
        let leftStackView = UIStackView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(leftStackView)
        headerView.addSubview(rightStackView)
        leftStackView.setupHorizontal(spacing: 2*defaultInset)
        leftStackView.placeAfter(anchor: headerView.leadingAnchor, insets: defaultInsets)
        rightStackView.setupHorizontal(spacing: 2*defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, insets: defaultInsets)
        
        addEmptyButton.addTarget(self, action: #selector(addEmptyEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addEmptyButton)
        addTextButton.addTarget(self, action: #selector(addTextEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addTextButton)
        addPhotoButton.addTarget(self, action: #selector(addPhotoEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addPhotoButton)
        addAudioButton.addTarget(self, action: #selector(addAudioEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addAudioButton)
        addVideoButton.addTarget(self, action: #selector(addVideoEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addVideoButton)
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchDown)
        rightStackView.addArrangedSubview(editButton)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        self.headerView = headerView
    }
    
    func setNeedsUpdate(){
        tableView.reloadData()
    }
    
    func updateBackground(){
        backgroundView.image = Settings.shared.backgroundImage
        tableView.setNeedsLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstAppearance{
            if globalData.days.count > 0 && globalData.days[0].entries.count > 0{
                tableView.scrollToRow(at: .init(row: globalData.days[globalData.days.count - 1].entries.count - 1, section: globalData.days.count-1), at: .bottom, animated: true)
            }
            firstAppearance = false
        }
    }
    
    // MainHeaderActionDelegate
    
    func openEntryController() -> EditEntryViewController{
        let createEventViewController = EditEntryViewController()
        let entry = EntryData(isNew: true)
        entry.location = LocationService.shared.getLocation()
        entry.locationDescription = LocationService.shared.getLocationDescription()
        createEventViewController.entry = entry
        createEventViewController.delegate = self
        createEventViewController.modalPresentationStyle = .fullScreen
        self.present(createEventViewController, animated: true)
        return createEventViewController
    }
    
    @objc func addEmptyEntry(){
        _ = openEntryController()
    }
    
    @objc func addTextEntry(){
        openEntryController().addText()
    }
    
    @objc func addPhotoEntry(){
        openEntryController().addImage()
    }
    
    @objc func addAudioEntry(){
        openEntryController().addAudio()
    }
    
    @objc func addVideoEntry(){
        openEntryController().addVideo()
    }
    
    @objc func toggleEditMode(){
        if !tableView.isEditing{
            editButton.tintColor = .systemRed
            tableView.setEditing(true, animated: true)
        }
        else{
            editButton.tintColor = .systemBlue
            tableView.setEditing(false, animated: true)
        }
        tableView.reloadData()
    }
    
    @objc func showInfo(){
        let infoController = TimelineInfoViewController()
        self.present(infoController, animated: true)
    }

    // SaveEntryDelegate
    
    func saveEntry(entry: EntryData) {
        if entry.isNew {
            let day = globalData.assertDay(date: entry.creationDate)
            day.addEntry(entry: entry)
        }
        globalData.save()
        tableView.reloadData()
        if entry.isNew {
            if globalData.days.count > 0 && globalData.days[0].entries.count > 0{
                let section = globalData.days.count-1
                let row = globalData.days[globalData.days.count - 1].entries.count - 1
                tableView.scrollToRow(at: .init(row: row, section: section), at: .bottom, animated: true)
            }
            entry.isNew = false
        }
        if let mapController = MainTabController.getMapViewController(){
            mapController.setNeedsUpdate()
        }
    }
    
    // EntryActionDelegate
    
    func editEntry(entry: EntryData) {
        let editEntryViewController = EditEntryViewController()
        editEntryViewController.entry = entry
        editEntryViewController.delegate = self
        editEntryViewController.modalPresentationStyle = .fullScreen
        self.present(editEntryViewController, animated: true)
    }
    
    func deleteEntry(entry: EntryData) {
        showApprove(title: "reallyDeleteEntry".localize(), text: "deleteEntryApproveInfo".localize()){
            self.globalData.deleteEntry(entry: entry)
            self.tableView.reloadData()
        }
    }
    
    func viewEntry(entry: EntryData) {
        let entryController = EntryViewController()
        entryController.entry = entry
        entryController.modalPresentationStyle = .fullScreen
        self.present(entryController, animated: true)
    }
    
    func viewPhotoItem(data: PhotoData) {
        let photoViewController = PhotoViewController()
        photoViewController.uiImage = data.getImage()
        photoViewController.modalPresentationStyle = .fullScreen
        self.present(photoViewController, animated: true)
    }
    
    func sharePhotoItem(data: PhotoData) {
        let alertController = UIAlertController(title: title, message: "shareImage".localize(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "imageLibrary".localize(), style: .default) { action in
            FileController.copyImageToLibrary(name: data.fileName, fromDir: FileController.privateURL){ result in
                DispatchQueue.main.async {
                    switch result{
                    case .success:
                        self.showAlert(title: "success".localize(), text: "photoShared".localize())
                    case .failure(let err):
                        self.showAlert(title: "error".localize(), text: err.errorDescription!)
                    }
                }
            }
        })
        alertController.addAction(UIAlertAction(title: "ownDocuments".localize(), style: .default) { action in
            if FileController.copyFile(name: data.fileName, fromDir: FileController.privateURL, toDir: FileController.exportDirURL, replace: true){
                self.showAlert(title: "success".localize(), text: "photoShared".localize())
            }
            else{
                self.showAlert(title: "error".localize(), text: "copyError".localize())
            }
        })
        alertController.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
        self.present(alertController, animated: true)
    }
    
    func viewVideoItem(data: VideoData) {
        let videoViewController = VideoViewController()
        videoViewController.videoURL = data.fileURL
        videoViewController.modalPresentationStyle = .fullScreen
        self.present(videoViewController, animated: true)
    }
    
    func shareVideoItem(data: VideoData) {
        let alertController = UIAlertController(title: title, message: "shareImage".localize(), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "imageLibrary".localize(), style: .default) { action in
            FileController.copyVideoToLibrary(name: data.fileName, fromDir: FileController.privateURL){ result in
                DispatchQueue.main.async {
                    switch result{
                    case .success:
                        self.showAlert(title: "success".localize(), text: "videoShared".localize())
                        return
                    case .failure(let err):
                        self.showAlert(title: "error".localize(), text: err.errorDescription!)
                    }
                }
            }
        })
        alertController.addAction(UIAlertAction(title: "ownDocuments".localize(), style: .default) { action in
            if FileController.copyFile(name: data.fileName, fromDir: FileController.privateURL, toDir: FileController.exportDirURL, replace: true){
                self.showAlert(title: "success".localize(), text: "videoShared".localize())
            }
            else{
                self.showAlert(title: "error".localize(), text: "copyError".localize())
            }
        })
        alertController.addAction(UIAlertAction(title: "cancel".localize(), style: .cancel))
        self.present(alertController, animated: true)
    }
    
    // table view callbacks
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return globalData.days.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TimelineSectionHeader()
        headerView.setupView(day: globalData.days[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = globalData.days[section]
        return day.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineViewController.CELL_IDENT, for: indexPath) as! TimelineEntryCell
        let day = globalData.days[indexPath.section]
        let event = day.entries[indexPath.row]
        cell.entry = event
        cell.delegate = self
        cell.updateCell(isEditing: tableView.isEditing)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

}


