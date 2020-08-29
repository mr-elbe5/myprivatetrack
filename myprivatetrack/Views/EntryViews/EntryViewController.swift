//
//  EntryViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 16.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class EntryViewController: ModalScrollViewController, ImageItemDelegate, VideoItemDelegate {
    
    var entry : EntryData!
    
    var stackView = UIStackView()
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        let label = InfoHeader(text: entry.creationDate.dateTimeString())
        stackView.addArrangedSubview(label)
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
            case .image:
                let itemView = ImageItemView.fromData(data: item.data as! ImageData,delegate: self)
                stackView.addArrangedSubview(itemView)
                break
            case .video:
                let itemView = VideoItemView.fromData(data: item.data as! VideoData,delegate: self)
                stackView.addArrangedSubview(itemView)
                break
            case .location:
                let itemView = LocationItemView.fromData(data: item.data as! LocationData)
                stackView.addArrangedSubview(itemView)
                break
            }
        }
    }
    
    func viewImageItem(data: ImageData) {
        let imageViewController = ImageViewController()
        imageViewController.uiImage = data.getImage()
        imageViewController.modalPresentationStyle = .fullScreen
        self.present(imageViewController, animated: true)
    }
    
    func viewVideoItem(data: VideoData) {
        let videoViewController = VideoViewController()
        videoViewController.videoURL = data.fileURL
        videoViewController.modalPresentationStyle = .fullScreen
        self.present(videoViewController, animated: true)
    }
    
}
