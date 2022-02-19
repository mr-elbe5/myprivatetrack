/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

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
            .iconHeight()
        return deleteButton
    }
    
    @objc func deleteItem(){
        delegate?.deleteItem(itemView: self)
    }
    
}
