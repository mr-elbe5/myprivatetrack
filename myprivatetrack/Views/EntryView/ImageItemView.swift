//
//  ImageItemView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol ImageItemDelegate{
    func viewImageItem(data: ImageData)
}

class ImageItemView : EntryItemView{
    
    static func fromData(data : ImageData,delegate : ImageItemDelegate? = nil)  -> ImageItemView{
        let itemView = ImageItemView()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var imageData : ImageData? = nil
    
    var delegate : ImageItemDelegate? = nil
    
    var imageView = UIImageView()
    
    func setupView(data: ImageData){
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        self.imageData = data
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
        if delegate != nil{
            let viewButton = ViewDetailButton()
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            addSubview(viewButton)
            viewButton.placeTopRight(padding: doubleInsets)
        }
    }
    
    @objc func viewItem(){
        if let imageData = imageData{
            delegate?.viewImageItem(data: imageData)
        }
    }
    
}

class ImageItemDetailView : EntryItemDetailView{
    
    var imageData : ImageData? = nil
    
    var imageView = UIImageView()
    
    static func fromData(data : ImageData)  -> ImageItemDetailView{
        let itemView = ImageItemDetailView()
        itemView.setupView(data: data)
        return itemView
    }
    
    func setupView(data: ImageData){
        imageView.setDefaults()
        addSubview(imageView)
        self.imageData = data
        imageView.image = data.getImage()
        imageView.fillSuperview()
    }
    
}

class ImageItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : ImageData)  -> ImageItemEditView{
        let editView = ImageItemEditView()
        editView.setupSubviews()
        editView.setupData(data: data)
        editView.setLayoutConstraints()
        return editView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var imageData : ImageData!
    
    override var data: EntryItemData{
        get{
            return imageData
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
    
    func setupData(data: ImageData){
        self.imageData = data
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
        if imageData != nil{
            imageData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
