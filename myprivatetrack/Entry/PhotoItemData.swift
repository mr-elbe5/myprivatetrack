/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class PhotoItemData : FileEntryItemData{
    
    enum PhotoEntryCodingKeys: String, CodingKey {
        case title
    }
    
    var title: String = ""
    
    private var image : UIImage? = nil
    
    override var type : EntryItemType{
        get{
            return .photo
        }
    }
    
    override var fileName : String {
        get{
            return "img_\(creationDate.fileDate()).jpg"
        }
    }
    
    init(){
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PhotoEntryCodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: PhotoEntryCodingKeys.self)
        try container.encode(title, forKey: .title)
    }
    
    func getImage() -> UIImage?{
        if let data = getFile(){
            return UIImage(data: data)
        } else{
            return nil
        }
    }
    
    func saveImage(uiImage: UIImage){
        if let data = uiImage.jpegData(compressionQuality: 0.8){
            saveFile(data: data)
        }
    }
    
}
