//
//  ImageItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol ImageItemDelegate{
    func viewImageItem(data: ImageData)
    func shareImageItem(data: ImageData)
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
            let sv = UIStackView()
            sv.setupHorizontal(distribution: .fillEqually, spacing: 2*defaultInset)
            addSubview(sv)
            sv.placeTopRight(padding: doubleInsets)
            let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue, backgroundColor: .systemBackground)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            sv.addArrangedSubview(viewButton)
            let shareButton = IconButton(icon: "square.and.arrow.up", tintColor: .systemBlue, backgroundColor: .systemBackground)
            shareButton.addTarget(self, action: #selector(shareItem), for: .touchDown)
            sv.addArrangedSubview(shareButton)
        }
    }
    
    @objc func viewItem(){
        if let imageData = imageData{
            delegate?.viewImageItem(data: imageData)
        }
    }
    
    @objc func shareItem(){
        if let imageData = imageData{
            delegate?.shareImageItem(data: imageData)
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
    
    override func setFocus(){
        titleView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if imageData != nil{
            imageData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
