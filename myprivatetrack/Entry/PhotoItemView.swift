//
//  ImageItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoItemDelegate{
    func viewPhotoItem(data: PhotoItemData)
    func sharePhotoItem(data: PhotoItemData)
}

class PhotoItemView : EntryItemView{
    
    static func fromData(data : PhotoItemData, backgroundColor: UIColor? = nil, delegate : PhotoItemDelegate? = nil)  -> PhotoItemView{
        let itemView = PhotoItemView()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var photoData : PhotoItemData? = nil
    
    var delegate : PhotoItemDelegate? = nil
    
    var imageView = UIImageView()
    
    func setupView(data: PhotoItemData){
        imageView.setDefaults()
        imageView.setRoundedBorders(radius: 10)
        imageView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        addSubview(imageView)
        self.photoData = data
        imageView.image = data.getImage()
        imageView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        imageView.setAspectRatioConstraint()
        if !data.title.isEmpty{
            let titleView = MediaCommentLabel(text: data.title)
            addSubview(titleView)
            titleView.setAnchors(leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
                .top(imageView.bottomAnchor, inset: 0)
        }
        else{
            imageView.bottom(bottomAnchor, inset: -defaultInset)
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
        if let imageData = photoData{
            delegate?.viewPhotoItem(data: imageData)
        }
    }
    
    @objc func shareItem(){
        if let imageData = photoData{
            delegate?.sharePhotoItem(data: imageData)
        }
    }
    
}

class PhotoItemDetailView : EntryItemDetailView{
    
    var photoData : PhotoItemData? = nil
    
    var imageView = UIImageView()
    
    static func fromData(data : PhotoItemData)  -> PhotoItemDetailView{
        let itemView = PhotoItemDetailView()
        itemView.setupView(data: data)
        return itemView
    }
    
    func setupView(data: PhotoItemData){
        imageView.setDefaults()
        addSubview(imageView)
        self.photoData = data
        imageView.image = data.getImage()
        imageView.fillView(view: self)
    }
    
}

class PhotoItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : PhotoItemData)  -> PhotoItemEditView{
        let editView = PhotoItemEditView()
        editView.setupView(data: data)
        return editView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var photoData : PhotoItemData!
    
    override var data: EntryItemData{
        get{
            return photoData
        }
    }
    
    var imageView = UIImageView()
    var titleView = TextEditArea()
    
    private func setupView(data: PhotoItemData){
        self.photoData = data
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
        if photoData != nil{
            photoData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}
