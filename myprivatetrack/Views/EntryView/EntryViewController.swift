//
//  EntryViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 16.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class EntryViewController: ModalScrollViewController {
    
    var entry : EntryData!
    
    override func loadView() {
        super.loadView()
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
                let itemView = ImageItemView.fromData(data: item.data as! ImageData)
                stackView.addArrangedSubview(itemView)
                break
            case .video:
                let itemView = VideoItemView.fromData(data: item.data as! VideoData)
                stackView.addArrangedSubview(itemView)
                break
            case .location:
                let itemView = LocationItemView.fromData(data: item.data as! LocationData)
                stackView.addArrangedSubview(itemView)
                break
            }
        }
    }
    
}
