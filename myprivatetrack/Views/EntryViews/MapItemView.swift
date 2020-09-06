//
//  LocationItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class MapItemView : EntryItemView{
    
    static func fromData(data : EntryData)  -> MapItemView{
        let itemView = MapItemView()
        itemView.setupView(data: data)
        return itemView
    }
    
    var imageView = UIImageView()
    
    func setupView(data: EntryData){
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        imageView.image = data.getMapSection()
        imageView.placeBelow(anchor: topAnchor)
        imageView.setAspectRatioConstraint()
        imageView.connectBottom(view: self)
    }
    
}



