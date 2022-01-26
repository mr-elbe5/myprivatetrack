//
//  LocationItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol MapItemDelegate{
    func viewMapItem(data: MapPhotoItemData)
    func shareMapItem(data: MapPhotoItemData)
}

class MapItemView : EntryItemView{
    
    static func fromData(data : MapPhotoItemData,delegate : MapItemDelegate? = nil)  -> MapItemView{
        let itemView = MapItemView()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var mapData : MapPhotoItemData? = nil
    
    var delegate : MapItemDelegate? = nil
    
    var imageView = UIImageView()
    
    func setupView(data: MapPhotoItemData){
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        self.mapData = data
        imageView.image = data.getImage()
        imageView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        imageView.setAspectRatioConstraint()
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.setAnchors(top: imageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        }
        else{
            imageView.bottom(bottomAnchor)
        }
        if delegate != nil{
            let sv = UIStackView()
            sv.setupHorizontal(distribution: .fillEqually, spacing: 2*defaultInset)
            addSubview(sv)
            sv.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: doubleInsets)
            let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue, backgroundColor: transparentColor)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            sv.addArrangedSubview(viewButton)
            let shareButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue, backgroundColor: transparentColor)
            shareButton.addTarget(self, action: #selector(shareItem), for: .touchDown)
            sv.addArrangedSubview(shareButton)
        }
    }
    
    @objc func viewItem(){
        if let imageData = mapData{
            delegate?.viewMapItem(data: imageData)
        }
    }
    
    @objc func shareItem(){
        if let imageData = mapData{
            delegate?.shareMapItem(data: imageData)
        }
    }
    
}

class MapItemDetailView : EntryItemDetailView{
    
    var mapData : MapPhotoItemData? = nil
    
    var imageView = UIImageView()
    
    static func fromData(data : MapPhotoItemData)  -> MapItemDetailView{
        let itemView = MapItemDetailView()
        itemView.setupView(data: data)
        return itemView
    }
    
    func setupView(data: MapPhotoItemData){
        imageView.setDefaults()
        addSubview(imageView)
        self.mapData = data
        imageView.image = data.getImage()
        imageView.fillView(view: self)
    }
    
}

class MapItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : MapPhotoItemData)  -> MapItemEditView{
        let editView = MapItemEditView()
        editView.setupView(data: data)
        return editView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var mapData : MapPhotoItemData!
    
    override var data: EntryItemData{
        get{
            return mapData
        }
    }
    
    var imageView = UIImageView()
    var titleView = TextEditArea()
    
    private func setupView(data: MapPhotoItemData){
        self.mapData = data
        imageView.image = data.getImage()
        titleView.setText(data.title)
        let deleteButton = addDeleteButton()
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        titleView.setDefaults(placeholder: "comment".localize())
        titleView.delegate = self
        addSubview(titleView)
        titleView.setKeyboardToolbar(doneTitle: "done".localize())
        imageView.setAnchors(top: deleteButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: deleteInsets)
        imageView.setAspectRatioConstraint()
        titleView.setAnchors(top: imageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
    }
    
    override func setFocus(){
        titleView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if mapData != nil{
            mapData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}



