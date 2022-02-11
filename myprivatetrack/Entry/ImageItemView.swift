/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

protocol ImageItemDelegate{
    func viewImageItem(data: ImageItemData)
    func shareImageItem(data: ImageItemData)
}

class ImageItemView : EntryItemView{
    
    static func fromData(data : ImageItemData, backgroundColor: UIColor? = nil, delegate : ImageItemDelegate? = nil)  -> ImageItemView{
        let itemView = ImageItemView()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var imageData : ImageItemData? = nil
    
    var delegate : ImageItemDelegate? = nil
    
    var imageView = UIImageView()
    
    func setupView(data: ImageItemData){
        imageView.setDefaults()
        imageView.setRoundedBorders(radius: 10)
        imageView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        addSubview(imageView)
        self.imageData = data
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
        setupLinks()
    }
    
    func setupLinks(){
        if delegate != nil{
            let sv = UIStackView()
            sv.setupHorizontal(distribution: .fillEqually, spacing: 2*defaultInset)
            addSubview(sv)
            sv.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: doubleInsets)
            let viewButton = IconButton(icon: "magnifyingglass", backgroundColor: transparentColor)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            sv.addArrangedSubview(viewButton)
            let shareButton = IconButton(icon: "square.and.arrow.up", backgroundColor: transparentColor)
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

class ImageItemPreview: ImageItemView{
    
    static func previewFromData(data : ImageItemData,delegate: ImageItemDelegate? = nil)  -> ImageItemPreview{
        let itemView = ImageItemPreview()
        itemView.delegate = delegate
        itemView.setupView(data: data)
        return itemView
    }
    
    override func setupLinks(){
        if delegate != nil{
            let viewButton = IconButton(icon: "magnifyingglass", backgroundColor: transparentColor)
            viewButton.addTarget(self, action: #selector(viewItem), for: .touchDown)
            addSubview(viewButton)
            viewButton.setAnchors(top: imageView.topAnchor, trailing: imageView.trailingAnchor, insets: smallInsets)
        }
    }
    
}

class ImageItemDetailView : EntryItemDetailView{
    
    var imageData : ImageItemData? = nil
    
    var imageView = UIImageView()
    
    static func fromData(data : ImageItemData)  -> ImageItemDetailView{
        let itemView = ImageItemDetailView()
        itemView.setupView(data: data)
        return itemView
    }
    
    func setupView(data: ImageItemData){
        imageView.setDefaults()
        addSubview(imageView)
        self.imageData = data
        imageView.image = data.getImage()
        imageView.fillView(view: self)
    }
    
}

class ImageItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : ImageItemData)  -> ImageItemEditView{
        let editView = ImageItemEditView()
        editView.setupView(data: data)
        return editView
    }
    
    fileprivate var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    var imageData : ImageItemData!
    
    override var data: EntryItemData{
        get{
            return imageData
        }
    }
    
    var imageView = UIImageView()
    var titleView = TextEditArea()
    
    private func setupView(data: ImageItemData){
        self.imageData = data
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
        if imageData != nil{
            imageData!.title = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}

