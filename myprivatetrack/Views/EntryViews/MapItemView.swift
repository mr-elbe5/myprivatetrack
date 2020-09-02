//
//  LocationItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class MapItemView : EntryItemView{
    
    static func fromData(data : MapData)  -> MapItemView{
        let itemView = MapItemView()
        itemView.setupView(data: data)
        return itemView
    }
    
    var locationData : MapData? = nil
    
    var imageView = UIImageView()
    
    func setupView(data: MapData){
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
    
    static func fromData(data : MapData)  -> LocationItemDetailView{
        let itemView = LocationItemDetailView()
        itemView.setupView(data: data)
        return itemView
    }
    
    var locationData : MapData? = nil
    
    var imageView = UIImageView()
    
    func setupView(data: MapData){
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        self.locationData = data
        imageView.image = data.getImage()
        imageView.fillSuperview()
    }
}

class LocationItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : MapData)  -> LocationItemEditView{
        let editView = LocationItemEditView()
        editView.setupSubviews()
        editView.setupData(data: data)
        editView.setLayoutConstraints()
        return editView
    }
    
    var locationData : MapData!
    
    override var data: EntryItemData{
        get{
            return locationData
        }
    }
    
    var imageView = UIImageView()
    var titleView = TextEditArea()

    override func setupSubviews(){
        addTopControl()
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        titleView.setDefaults(placeholder: "comment".localize())
        titleView.delegate = self
        addSubview(titleView)
        titleView.setKeyboardToolbar()
    }
    
    func setupData(data: MapData){
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
    
    override func setFocus(){
        titleView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if locationData != nil{
            locationData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
