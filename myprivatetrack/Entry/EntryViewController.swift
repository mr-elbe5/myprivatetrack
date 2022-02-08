//
//  EntryViewController.swift
//
//  Created by Michael Rönnau on 16.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class EntryViewController: ModalScrollViewController, PhotoItemDelegate, VideoItemDelegate {
    
    var entry : EntryData!
    
    var stackView = UIStackView()
    
    var delegate : SaveEntryDelegate? = nil
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillView(view: scrollView, insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        updateView()
    }
    
    func updateView(){
        stackView.removeAllArrangedSubviews()
        let timeLabel = InfoHeader(text: entry.creationDate.dateTimeString())
        timeLabel.label.textAlignment = .center
        stackView.addArrangedSubview(timeLabel)
        if entry.showLocation, let loc = entry.location{
            let locationButton = TextButton(text: loc.asString)
            locationButton.addTarget(self,action: #selector(showInMap), for: .touchDown)
            stackView.addArrangedSubview(locationButton)
            let desc = entry!.locationDescription
            if !desc.isEmpty{
                let locationDescriptionLabel = UILabel()
                locationDescriptionLabel.text = desc
                locationDescriptionLabel.textAlignment = .center
                stackView.addArrangedSubview(locationDescriptionLabel)
            }
        }
        for item in entry.items{
            switch item.type{
            case .text:
                let itemView = TextItemView.fromData(data: item.data as! TextItemData)
                stackView.addArrangedSubview(itemView)
                break
            case .audio:
                let itemView = AudioItemView.fromData(data: item.data as! AudioData)
                stackView.addArrangedSubview(itemView)
                break
            case .photo:
                let itemView = PhotoItemView.fromData(data: item.data as! PhotoItemData,delegate: self)
                stackView.addArrangedSubview(itemView)
                break
            case .video:
                let itemView = VideoItemView.fromData(data: item.data as! VideoItemData,delegate: self)
                stackView.addArrangedSubview(itemView)
                break
            }
        }
    }
    
    override open func setupHeaderView(){
        super.setupHeaderView()
        let editButton = IconButton(icon: "pencil.circle")
        editButton.addTarget(self, action: #selector(editEntry), for: .touchDown)
        buttonView.addSubview(editButton)
        editButton.setAnchors(top: buttonView.topAnchor, trailing: closeButton.leadingAnchor, bottom: buttonView.bottomAnchor, insets: defaultInsets)
    }
    
    @objc func showInMap(){
        if let location = entry?.location{
            self.dismiss(animated: false)
            let mapController = MainTabController.getMapViewController()
            mapController?.mkMapView.centerToLocation(location, regionRadius: 1000)
            MainTabController.instance.selectedViewController = mapController
        }
    }
    
    func viewPhotoItem(data: PhotoItemData) {
        let imageViewController = PhotoViewController()
        imageViewController.uiImage = data.getImage()
        imageViewController.modalPresentationStyle = .fullScreen
        self.present(imageViewController, animated: true)
    }
    
    func sharePhotoItem(data: PhotoItemData) {
        print("share")
    }
    
    func viewVideoItem(data: VideoItemData) {
        let videoViewController = VideoViewController()
        videoViewController.videoURL = data.fileURL
        videoViewController.modalPresentationStyle = .fullScreen
        self.present(videoViewController, animated: true)
    }
    
    func shareVideoItem(data: VideoItemData) {
        print("share")
    }
    
    @objc func editEntry(){
        let editEntryViewController = EditEntryViewController()
        editEntryViewController.entry = entry
        editEntryViewController.delegate = self
        editEntryViewController.modalPresentationStyle = .fullScreen
        self.present(editEntryViewController, animated: true)
    }
    
}

extension EntryViewController : SaveEntryDelegate{
    
    func saveEntry(entry: EntryData) {
        updateView()
        delegate?.saveEntry(entry: entry)
    }
}
