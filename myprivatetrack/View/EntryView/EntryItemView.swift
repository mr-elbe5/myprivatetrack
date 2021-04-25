//
//  EntryItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import SwiftyIOSViewExtensions

protocol DeleteEntryActionDelegate{
    func deleteItem(itemView: EntryItemEditView)
}

class EntryItemView : UIView{
    
}

class EntryItemDetailView : UIView{
    
}

class EntryItemEditView : UIView{
    
    var deleteInsets = UIEdgeInsets(top: 0, left: Statics.defaultInset, bottom: Statics.defaultInset/2, right: Statics.defaultInset)
    
    var delegate : DeleteEntryActionDelegate? = nil
    
    var data: EntryItemData{
        get{
            fatalError("not implemented")
        }
    }
    
    func addDeleteButton() -> IconButton{
        let deleteButton = IconButton(icon: "xmark.circle")
        deleteButton.tintColor = UIColor.systemRed
        deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchDown)
        addSubview(deleteButton)
        deleteButton.setAnchors()
            .top(topAnchor, inset: defaultInset / 2)
            .trailing(trailingAnchor, inset: Statics.defaultInset)
        return deleteButton
    }
    
    func setFocus(){
    }
    
    @objc func deleteItem(){
        delegate?.deleteItem(itemView: self)
    }
    
}
