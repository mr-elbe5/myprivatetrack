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
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        let timeLabel = InfoHeader(text: entry.creationDate.dateTimeString())
        timeLabel.label.textAlignment = .center
        stackView.addArrangedSubview(timeLabel)
        if entry.saveLocation, let loc = entry.location{
            let locationButton = TextButton(text: loc.asString)
            locationButton.addTarget(self,action: #selector(showInMap), for: .touchDown)
            stackView.addArrangedSubview(locationButton)
            if entry!.hasMapSection{
                let mapView = MapItemView()
                mapView.setupView(data: entry!)
                stackView.addArrangedSubview(mapView)
            }
        }
        for item in entry.items{
            switch item.type{
            case .text:
                let itemView = TextItemView.fromData(data: item.data as! TextData)
                stackView.addArrangedSubview(itemView)
                break
            case .audio:
                let itemView = AudioItemView.fromData(data: item.data as! AudioData)
                stackView.addArrangedSubview(itemView)
                break
            case .photo:
                let itemView = PhotoItemView.fromData(data: item.data as! PhotoData,delegate: self)
                stackView.addArrangedSubview(itemView)
                break
            case .video:
                let itemView = VideoItemView.fromData(data: item.data as! VideoData,delegate: self)
                stackView.addArrangedSubview(itemView)
                break
            }
        }
    }
    
    @objc func showInMap(){
        if let location = entry?.location{
            self.dismiss(animated: false)
            let mapController = MainTabController.getMapViewController()
            mapController?.mkMapView.centerToLocation(location)
            MainTabController.instance.selectedViewController = mapController
        }
    }
    
    func viewPhotoItem(data: PhotoData) {
        let imageViewController = PhotoViewController()
        imageViewController.uiImage = data.getImage()
        imageViewController.modalPresentationStyle = .fullScreen
        self.present(imageViewController, animated: true)
    }
    
    func sharePhotoItem(data: PhotoData) {
        print("share")
    }
    
    func viewVideoItem(data: VideoData) {
        let videoViewController = VideoViewController()
        videoViewController.videoURL = data.fileURL
        videoViewController.modalPresentationStyle = .fullScreen
        self.present(videoViewController, animated: true)
    }
    
    func shareVideoItem(data: VideoData) {
        print("share")
    }
    
}
