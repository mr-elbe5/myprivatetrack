/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit


class TimelineViewController: UIViewController{
    
    private static let CELL_IDENT = "entryCell"
    
    var firstAppearance = true
    
    var headerView = TimelineHeaderView()
    var tableView = UITableView()
    var createEntryView = CreateQuickEntryView()
    var createEntryBottomConstraint : NSLayoutConstraint!
    var backgroundView = UIImageView(image: Settings.shared.backgroundImage)
    
    override open func loadView() {
        super.loadView()
        view.backgroundColor = .systemGray5
        let guide = view.safeAreaLayoutGuide
        let spacer = UIView()
        spacer.backgroundColor = .systemGray3
        view.addSubview(spacer)
        spacer.setAnchors(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: guide.topAnchor, insets: .zero)
        headerView.setupView()
        headerView.delegate = self
        view.addSubview(headerView)
        headerView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: defaultInsets)
        view.addSubview(tableView)
        tableView.setAnchors(top: headerView.bottomAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: defaultInsets)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        backgroundView.contentMode = UIView.ContentMode.scaleAspectFill;
        tableView.backgroundView = backgroundView
        tableView.register(TimelineEntryCell.self, forCellReuseIdentifier: TimelineViewController.CELL_IDENT)
        tableView.allowsSelection = false
        tableView.allowsSelectionDuringEditing = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        createEntryView.setupView()
        createEntryView.delegate = self
        view.addSubview(createEntryView)
        createEntryView.setAnchors(top: tableView.bottomAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: defaultInsets)
        createEntryBottomConstraint = createEntryView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -defaultInset)
        createEntryBottomConstraint.isActive = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
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
            if GlobalData.shared.days.count > 0 && GlobalData.shared.days[0].entries.count > 0{
                tableView.scrollToRow(at: .init(row: GlobalData.shared.days[GlobalData.shared.days.count - 1].entries.count - 1, section: GlobalData.shared.days.count-1), at: .bottom, animated: true)
            }
            firstAppearance = false
        }
    }
    
    @objc func keyboardDidShow(notification:NSNotification){
        let tabHeight = MainTabController.instance.tabBar.bounds.height
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        createEntryBottomConstraint.constant = -keyboardFrame.height + tabHeight - defaultInset
        updateViewConstraints()
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        createEntryBottomConstraint.constant = -defaultInset
        updateViewConstraints()
    }
    
}

extension TimelineViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return GlobalData.shared.days.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TimelineSectionHeader()
        headerView.setupView(day: GlobalData.shared.days[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = GlobalData.shared.days[section]
        return day.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineViewController.CELL_IDENT, for: indexPath) as! TimelineEntryCell
        let day = GlobalData.shared.days[indexPath.section]
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

extension TimelineViewController : TimelineHeaderDelegate{
    
    func toggleEditMode(){
        if !tableView.isEditing{
            headerView.editButton.tintColor = .systemRed
            tableView.setEditing(true, animated: true)
        }
        else{
            headerView.editButton.tintColor = .systemBlue
            tableView.setEditing(false, animated: true)
        }
        tableView.reloadData()
    }
    
    func showInfo(){
        let infoController = TimelineInfoViewController()
        self.present(infoController, animated: true)
    }
    
    func createTextEntry() {
        openCreateEntryController().addText()
    }
    
    func createPhotoEntry() {
        openCreateEntryController().addPhoto()
    }
    
    func createImageEntry() {
        openCreateEntryController().addImage()
    }
    
    func createAudioEntry() {
        openCreateEntryController().addAudio()
    }
    
    func createVideoEntry() {
        openCreateEntryController().addVideo()
    }
    
    func openCreateEntryController() -> EditEntryViewController{
        let entry = EntryData(isNew: true)
        entry.location = LocationService.shared.getLocation()
        entry.locationDescription = LocationService.shared.getLocationDescription()
        let editEntryViewController = EditEntryViewController()
        editEntryViewController.entry = entry
        editEntryViewController.delegate = self
        editEntryViewController.modalPresentationStyle = .fullScreen
        self.present(editEntryViewController, animated: true)
        return editEntryViewController
    }
    
}

extension TimelineViewController : CreateQuickEntryDelegate{
    
    func createQuickEntry(text: String) {
        let entry = EntryData(isNew: true)
        entry.location = LocationService.shared.getLocation()
        entry.locationDescription = LocationService.shared.getLocationDescription()
        let entryItem = TextItemData()
        entryItem.text = text
        entry.addItem(item: entryItem)
        saveEntry(entry: entry)
    }
    
}

extension TimelineViewController : SaveEntryDelegate{
    
    func saveEntry(entry: EntryData) {
        if entry.isNew {
            let day = GlobalData.shared.assertDay(date: entry.creationDate)
            day.addEntry(entry: entry)
        }
        GlobalData.shared.save()
        tableView.reloadData()
        if entry.isNew {
            if GlobalData.shared.days.count > 0 && GlobalData.shared.days[0].entries.count > 0{
                let section = GlobalData.shared.days.count-1
                let row = GlobalData.shared.days[GlobalData.shared.days.count - 1].entries.count - 1
                tableView.scrollToRow(at: .init(row: row, section: section), at: .bottom, animated: true)
            }
            entry.isNew = false
        }
        if let mapController = MainTabController.getMapViewController(){
            mapController.setNeedsUpdate()
        }
    }
}

extension TimelineViewController : TimelineEntryCellDelegate{
    
    func deleteEntry(entry: EntryData) {
        showApprove(title: "reallyDeleteEntry".localize(), text: "deleteEntryApproveInfo".localize()){
            GlobalData.shared.deleteEntry(entry: entry)
            self.tableView.reloadData()
        }
    }
    
    func viewEntry(entry: EntryData) {
        let entryController = EntryViewController()
        entryController.entry = entry
        entryController.delegate = self
        entryController.modalPresentationStyle = .fullScreen
        self.present(entryController, animated: true)
    }
    
}


