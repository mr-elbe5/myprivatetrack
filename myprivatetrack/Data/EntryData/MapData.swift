//
//  LocationData.swift
//
//  Created by Michael Rönnau on 12.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class MapData: ImageEntryItemData{
    
    private var image : UIImage? = nil
    
    override public var type : EntryItemType{
        get{
            return .map
        }
    }
    
    override var fileName : String {
        get{
            return "map_\(creationDate.fileDate()).jpg"
        }
    }
    
}
