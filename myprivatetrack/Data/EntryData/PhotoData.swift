//
//  PhotoData.swift
//
//  Created by Michael Rönnau on 04.04.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class PhotoData : ImageEntryItemData{
    
    private var image : UIImage? = nil
    
    override public var type : EntryItemType{
        get{
            return .photo
        }
    }
    
    override var fileName : String {
        get{
            return "img_\(creationDate.fileDate()).jpg"
        }
    }
    
}
