/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import AVFoundation
import CoreLocation

protocol SaveEntryDelegate{
    func saveEntry(entry: EntryData)
}

class EditEntryViewController: ScrollViewController{
    
    var delegate : SaveEntryDelegate? = nil
    
    var entry : EntryData!
    
    var addingItem = false
    
    var headerView = UIView()
    var stackView = UIStackView()
    
    var locationText = TextEditArea()
    var showLocationSwitch = SwitchView()
    var startAddingItemButton = IconButton(icon: "plus")
    var addTextButton = IconButton(icon: "text.bubble")
    var addPhotoButton = IconButton(icon: "camera")
    var addImageButton = IconButton(icon: "photo")
    var addAudioButton = IconButton(icon: "mic")
    let addVideoButton = IconButton(icon: "video")
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        let guide = view.safeAreaLayoutGuide
        setupHeaderView()
        view.addSubview(headerView)
        headerView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: .zero)
        setupScrollView()
        scrollView.setAnchors(leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: .zero)
            .top(headerView.bottomAnchor, inset: 1)
        scrollView.addSubview(stackView)
        stackView.fillView(view: scrollView, insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        locationText.setDefaults(placeholder: "locationDescription".localize())
        locationText.setText(entry.locationDescription)
        stackView.addArrangedSubview(locationText)
        showLocationSwitch.setEnabled(entry.location != nil)
        showLocationSwitch.setupView(labelText: "showLocation".localize(), isOn: entry.showLocation)
        stackView.addArrangedSubview(showLocationSwitch)
        for item in entry.items{
            var editItem : EntryItemEditView? = nil
            switch item.type{
            case .text:
                editItem = TextItemEditView.fromData(data: item.data as! TextItemData)
                editItem?.delegate = self
                break
            case .audio:
                editItem = AudioItemEditView.fromData(data: item.data as! AudioData)
                editItem?.delegate = self
                break
            case .photo:
                editItem = ImageItemEditView.fromData(data: item.data as! PhotoItemData)
                editItem?.delegate = self
                break
            case .image:
                editItem = ImageItemEditView.fromData(data: item.data as! ImageItemData)
                editItem?.delegate = self
                break
            case .video:
                editItem = VideoItemEditView.fromData(data: item.data as! VideoItemData)
                editItem?.delegate = self
                break
            }
            if let editItem = editItem{
                stackView.addArrangedSubview(editItem)
            }
        }
        let buttonContainer = ButtonStackView()
        buttonContainer.setupView()
        let saveButton = TextButton(text: "save".localize(), backgroundColor: .systemGray6)
        saveButton.addTarget(self, action: #selector(save), for: .touchDown)
        buttonContainer.stackView.addArrangedSubview(saveButton)
        let cancelButton = TextButton(text: "cancel".localize(), tintColor: .darkGray, backgroundColor: .systemGray6)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        buttonContainer.stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(buttonContainer)
        setupNotifications()
    }
    
    func setupHeaderView(){
        let stackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(stackView)
        stackView.setupHorizontal(spacing: 2*defaultInset)
        stackView.setAnchors(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        
        startAddingItemButton.addTarget(self, action: #selector(toggleAddItem), for: .touchDown)
        stackView.addArrangedSubview(startAddingItemButton)
        addTextButton.addTarget(self, action: #selector(addText), for: .touchDown)
        stackView.addArrangedSubview(addTextButton)
        addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchDown)
        stackView.addArrangedSubview(addPhotoButton)
        addImageButton.addTarget(self, action: #selector(addImage), for: .touchDown)
        stackView.addArrangedSubview(addImageButton)
        addAudioButton.addTarget(self, action: #selector(addAudio), for: .touchDown)
        stackView.addArrangedSubview(addAudioButton)
        addVideoButton.addTarget(self, action: #selector(addVideo), for: .touchDown)
        stackView.addArrangedSubview(addVideoButton)
        setAddItem(false)
    }
    
    @objc func toggleAddItem(){
        setAddItem(!addingItem)
    }
    
    private func setAddItem(_ flag: Bool){
        addingItem = flag
        addTextButton.isHidden = !addingItem
        addPhotoButton.isHidden = !addingItem
        addImageButton.isHidden = !addingItem
        addAudioButton.isHidden = !addingItem
        addVideoButton.isHidden = !addingItem
    }
    
    @objc func addText(){
        let data = TextItemData()
        entry.addItem(item: data)
        let editView = TextItemEditView.fromData(data: data)
        insertItemView(editView)
        setAddItem(false)
    }
    
    @objc func addPhoto(){
        AVCaptureDevice.askCameraAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = PhotoItemData()
                    let imageCaptureController = PhotoCaptureViewController()
                    imageCaptureController.data = data
                    imageCaptureController.delegate = self
                    imageCaptureController.modalPresentationStyle = .fullScreen
                    self.present(imageCaptureController, animated: true)
                }
                return
            case .failure:
                DispatchQueue.main.async {
                    self.showError("cameraNotAuthorized")
                }
                return
            }
        }
        setAddItem(false)
    }
    
    @objc func addImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        pickerController.modalPresentationStyle = .fullScreen
        self.present(pickerController, animated: true, completion: nil)
        setAddItem(false)
    }
    
    @objc func addAudio(){
        AVCaptureDevice.askAudioAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = AudioData()
                    self.entry.addItem(item: data)
                    let editView = AudioItemEditView.fromData(data: data)
                    self.insertItemView(editView)
                }
                return
            case .failure:
                DispatchQueue.main.async {
                    self.showError("audioNotAuthorized")
                }
                return
            }
        }
        setAddItem(false)
    }
    
    @objc func addVideo(){
        AVCaptureDevice.askVideoAuthorization(){ result in
            switch result{
            case .success(()):
                DispatchQueue.main.async {
                    let data = VideoItemData()
                    let videoCaptureController = VideoCaptureViewController()
                    videoCaptureController.data = data
                    videoCaptureController.delegate = self
                    videoCaptureController.modalPresentationStyle = .fullScreen
                    self.present(videoCaptureController, animated: true)
                }
                return
            case .failure:
                DispatchQueue.main.async {
                    self.showError("videoNotAuthorized")
                }
                return
            }
        }
        setAddItem(false)
    }
    
    @objc func save(){
        if (!entry.isComplete()){
            showAlert(title: "error".localize(), text: "notComplete".localize())
            return
        }
        entry.locationDescription = locationText.text
        entry.showLocation = showLocationSwitch.isOn
        delegate?.saveEntry(entry: entry)
        self.dismiss(animated: true)
    }
    
    @objc func cancel(){
        if entry.isNew{
            entry.removeAllItems()
        }
        self.dismiss(animated: true)
    }
    
    func insertItemView(_ editView: EntryItemEditView){
        editView.delegate = self
        stackView.insertArrangedSubview(editView, at: stackView.arrangedSubviews.count-1)
        scrollView.setNeedsLayout()
        DispatchQueue.main.async{
            self.scrollView.scrollToBottom()
        }
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
}

extension EditEntryViewController: PhotoCaptureDelegate{
    
    func photoCaptured(photo: PhotoItemData){
        entry.addItem(item: photo)
        let editView = ImageItemEditView.fromData(data: photo)
        insertItemView(editView)
    }
    
}

extension EditEntryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let imageURL = info[.imageURL] as? URL else {return}
        let data = ImageItemData()
        data.fileName = imageURL.lastPathComponent
        if FileController.copyFile(fromURL: imageURL, toURL: data.fileURL){
            self.entry.addItem(item: data)
            let editView = ImageItemEditView.fromData(data: data)
            self.insertItemView(editView)
        }
        picker.dismiss(animated: false)
    }
    
}

extension EditEntryViewController: VideoCaptureDelegate{
    
    func videoCaptured(data: VideoItemData){
        entry.addItem(item: data)
        let editView = VideoItemEditView.fromData(data: data)
        insertItemView(editView)
    }
    
}
    
extension EditEntryViewController: DeleteEntryActionDelegate{
    
    func deleteItem(itemView: EntryItemEditView) {
        showApprove(title: "reallyDeleteItem".localize(), text: "deleteItemApproveInfo".localize()){
            for v in self.stackView.arrangedSubviews{
                if v == itemView {
                    self.entry.removeItem(item: itemView.data)
                    self.stackView.removeArrangedSubview(itemView)
                    self.stackView.removeSubview(itemView)
                    break
                }
            }
        }
    }
    
}
    

