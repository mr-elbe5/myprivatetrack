/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class PhotoItemData : ImageItemData{
    
    override var type : EntryItemType{
        get{
            return .photo
        }
    }
    
    override var fileName : String {
        get{
            return "img_\(creationDate.fileDate()).jpg"
        }
        set{
            print("error: setting file name not implemented for PhotoItemData")
        }
    }
    
    override init(){
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
}
