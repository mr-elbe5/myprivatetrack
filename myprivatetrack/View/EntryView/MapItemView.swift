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
        imageView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        imageView.setAspectRatioConstraint()
        if !data.mapComment.isEmpty{
            let titleView = MediaCommentLabel(text: data.mapComment)
            addSubview(titleView)
            titleView.setAnchors(top: imageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        }
        else{
            imageView.bottom(bottomAnchor)
        }
    }
    
}

class MapItemEditView : EntryItemEditView, UITextViewDelegate{
    
    static func fromData(data : EntryData)  -> MapItemEditView{
        let editView = MapItemEditView()
        editView.setupView(data: data)
        return editView
    }
    
    var entry : EntryData? = nil
    
    var imageView = UIImageView()
    var titleView = TextEditArea()
    
    private func setupView(data: EntryData){
        self.entry = data
        imageView.image = data.getMapSection()
        titleView.setText(data.mapComment)
        imageView.setDefaults()
        imageView.setRoundedBorders()
        addSubview(imageView)
        titleView.setDefaults(placeholder: "mapComment".localize())
        titleView.delegate = self
        addSubview(titleView)
        titleView.setKeyboardToolbar()
        imageView.setAnchors(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, insets: defaultInsets)
        imageView.setAspectRatioConstraint()
        titleView.setAnchors(top: imageView.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: flatInsets)
    }
    
    // UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        if entry != nil{
            entry!.mapComment = textView.text!.trim()
        }
        titleView.textDidChange()
    }
    
}





