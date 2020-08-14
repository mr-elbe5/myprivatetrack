//
//  EntryItemDetailViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class EntryItemDetailViewController: ModalViewController {
    
    var item : EntryItemData!
    
    override func loadView() {
        super.loadView()
        self.modalPresentationStyle = .fullScreen
        var itemView : EntryItemDetailView? = nil
        switch item.type{
        case .image:
            itemView = ImageItemDetailView.fromData(data: item as! ImageData)
            break
        case .location:
            itemView = LocationItemDetailView.fromData(data: item as! LocationData)
            break
        default:
            break
        }
        if let itemView = itemView{
            stackView.addArrangedSubview(itemView)
        }
    }
    
}
