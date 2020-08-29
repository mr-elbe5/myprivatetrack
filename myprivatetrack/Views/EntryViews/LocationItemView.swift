//
//  LocationItemView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class LocationItemView : EntryItemView{
    
    static func fromData(data : LocationData)  -> LocationItemView{
        let itemView = LocationItemView()
        itemView.setupView(data: data)
        return itemView
    }
    
    var locationData : LocationData? = nil
    
    var imageView = UIImageView()
    
    func setupView(data: LocationData){
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        self.locationData = data
        imageView.image = data.getImage()
        imageView.placeBelow(anchor: topAnchor)
        imageView.setAspectRatioConstraint()
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.placeBelow(view: imageView)
            titleView.connectBottom(view: self)
        }
        else{
            imageView.connectBottom(view: self)
        }
    }
    
}

class LocationItemDetailView : EntryItemDetailView{
    
    static func fromData(data : LocationData)  -> LocationItemDetailView{
        let itemView = LocationItemDetailView()
        itemView.setupView(data: data)
        return itemView
    }
    
    var locationData : LocationData? = nil
    
    var imageView = UIImageView()
    
    func setupView(data: LocationData){
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        self.locationData = data
        imageView.image = data.getImage()
        imageView.fillSuperview()
    }
}

class LocationItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : LocationData)  -> LocationItemEditView{
        let editView = LocationItemEditView()
        editView.setupSubviews()
        editView.setupData(data: data)
        editView.setLayoutConstraints()
        return editView
    }
    
    var locationData : LocationData!
    
    override var data: EntryItemData{
        get{
            return locationData
        }
    }
    
    var imageView = UIImageView()
    var titleView = ResizingTextView()

    override func setupSubviews(){
        addTopControl()
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        titleView.setDefaults(placeholder: "comment".localize())
        titleView.delegate = self
        addSubview(titleView)
    }
    
    func setupData(data: LocationData){
        self.locationData = data
        imageView.image = data.getImage()
        titleView.text = data.title
    }
    
    override func setLayoutConstraints(){
        imageView.placeBelow(anchor: deleteButton.bottomAnchor, padding: flatInsets)
        imageView.setAspectRatioConstraint()
        titleView.placeBelow(view: imageView, padding: flatInsets)
        titleView.connectBottom(view: self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if locationData != nil{
            locationData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
