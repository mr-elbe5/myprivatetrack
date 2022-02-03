//
//  EntryItemView.swift
//
//  Created by Michael Rönnau on 20.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol DeleteEntryActionDelegate{
    func deleteItem(itemView: EntryItemEditView)
}

class EntryItemView : UIView{
    
}

class EntryItemDetailView : UIView{
    
}

class EntryItemEditView : UIView{
    
    var deleteInsets = UIEdgeInsets(top: Insets.defaultInset/2, left: Insets.defaultInset, bottom: Insets.defaultInset, right: Insets.defaultInset)
    
    var delegate : DeleteEntryActionDelegate? = nil
    
    var data: EntryItemData{
        get{
            fatalError("not implemented")
        }
    }
    
    func addDeleteButton() -> IconButton{
        let deleteButton = IconButton(icon: "trash")
        deleteButton.tintColor = UIColor.systemRed
        deleteButton.addTarget(self, action: #selector(deleteItem), for: .touchDown)
        addSubview(deleteButton)
        deleteButton.setAnchors(top: topAnchor, trailing: trailingAnchor, insets: flatInsets)
        return deleteButton
    }
    
    func setFocus(){
    }
    
    @objc func deleteItem(){
        delegate?.deleteItem(itemView: self)
    }
    
}
