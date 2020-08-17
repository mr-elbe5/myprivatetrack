//
//  TimelineViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

class TimelineViewController: TableViewController, SaveEntryDelegate, EntryActionDelegate{

    private static let CELL_IDENT = "entryCell"
    
    var firstAppearance = true
    
    var addTextButton = IconButton(icon: "text.bubble")
    var addImageButton = IconButton(icon: "camera")
    var addAudioButton = IconButton(icon: "mic")
    let addVideoButton = IconButton(icon: "video")
    var addLocationButton = IconButton(icon: "map")
    
    override func loadView(){
        super.loadView()
        tableView.backgroundColor = UIColor.clear
        let backgroundImage = UIImageView(image: UIImage(named: "meersonne"))
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill;
        tableView.backgroundView = backgroundImage
        tableView.register(EntryCell.self, forCellReuseIdentifier: TimelineViewController.CELL_IDENT)
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = Statics.defaultBackground
    }
    
    override func setupHeaderView(){
        let headerView = UIView()
        let leftStackView = UIStackView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(leftStackView)
        headerView.addSubview(rightStackView)
        leftStackView.setupHorizontal(spacing: defaultInset)
        leftStackView.placeAfter(anchor: headerView.leadingAnchor, padding: defaultInsets)
        rightStackView.setupHorizontal(spacing: defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, padding: defaultInsets)
        
        let addLabel = UILabel()
        addLabel.text = "+"
        addLabel.textColor = UIColor.label
        leftStackView.addArrangedSubview(addLabel)
        addTextButton.addTarget(self, action: #selector(addTextEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addTextButton)
        addImageButton.addTarget(self, action: #selector(addImageEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addImageButton)
        addAudioButton.addTarget(self, action: #selector(addAudioEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addAudioButton)
        addVideoButton.addTarget(self, action: #selector(addVideoEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addVideoButton)
        addLocationButton.addTarget(self, action: #selector(addLocationEntry), for: .touchDown)
        leftStackView.addArrangedSubview(addLocationButton)
        let editButton = IconButton(icon: "pencil.circle")
        editButton.addTarget(self, action: #selector(toggleEditMode), for: .touchDown)
        rightStackView.addArrangedSubview(editButton)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        
        self.headerView = headerView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if firstAppearance{
            if dataContainer.days.count > 0 , dataContainer.days[0].entries.count > 0{
                tableView.scrollToRow(at: .init(row: dataContainer.days[dataContainer.days.count - 1].entries.count - 1, section: dataContainer.days.count-1), at: .bottom, animated: true)
            }
            firstAppearance = false
        }
        addImageButton.isEnabled = Authorizations.isCameraAuthorized()
        addAudioButton.isEnabled = Authorizations.isAudioAuthorized()
        addVideoButton.isEnabled = Authorizations.isCameraAuthorized() && Authorizations.isAudioAuthorized()
        addLocationButton.isEnabled = DataStore.shared.settings.useLocation && Authorizations.isLocationAuthorized()
    }
    
    // MainHeaderActionDelegate
    
    func openEntryController() -> EditEntryViewController{
        let createEventViewController = EditEntryViewController()
        createEventViewController.entry = EntryData(isNew: true)
        if Authorizations.isLocationAuthorized(){
            createEventViewController.entry.location = Location(LocationService.shared.location)
        }
        createEventViewController.delegate = self
        createEventViewController.modalPresentationStyle = .fullScreen
        self.present(createEventViewController, animated: true)
        return createEventViewController
    }
    
    @objc func addTextEntry(){
        openEntryController().addText()
    }
    
    @objc func addImageEntry(){
        openEntryController().addImage()
    }
    
    @objc func addAudioEntry(){
        openEntryController().addAudio()
    }
    
    @objc func addVideoEntry(){
        openEntryController().addVideo()
    }
    
    @objc func addLocationEntry(){
        openEntryController().addLocation()
    }
    
    @objc func toggleEditMode(){
        if !tableView.isEditing{
            tableView.setEditing(true, animated: true)
        }
        else{
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
        print("save entry")
        if entry.isNew {
            let day = dataContainer.assertDay(date: entry.creationDate)
            day.addEntry(entry: entry)
            entry.isNew = false
            dataContainer.save()
            tableView.reloadData()
            if dataContainer.days.count > 0 , dataContainer.days[0].entries.count > 0{
                tableView.scrollToRow(at: .init(row: dataContainer.days[dataContainer.days.count - 1].entries.count - 1, section: dataContainer.days.count-1), at: .bottom, animated: true)
            }
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
        dataContainer.deleteEntry(entry: entry)
        tableView.reloadData()
    }
    
    func viewEntry(entry: EntryData) {
        let viewEntryViewController = EntryViewController()
        viewEntryViewController.entry = entry
        viewEntryViewController.modalPresentationStyle = .fullScreen
        self.present(viewEntryViewController, animated: true)
    }
    
    // table view callbacks
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataContainer.days.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = DaySectionHeader()
        headerView.setupView(day: dataContainer.days[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = dataContainer.days[section]
        return day.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineViewController.CELL_IDENT, for: indexPath) as! EntryCell
        let day = dataContainer.days[indexPath.section]
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


