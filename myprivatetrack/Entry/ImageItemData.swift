/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class ImageItemData : FileEntryItemData{
    
    enum ImageEntryCodingKeys: String, CodingKey {
        case title
        case fileName
    }
    
    var title: String = ""
    
    private var image : UIImage? = nil
    private var _fileName : String = ""
    
    override var type : EntryItemType{
        get{
            return .image
        }
    }
    
    override var fileName : String {
        get{
            return _fileName
        }
        set{
            _fileName = newValue
        }
    }
    
    init(){
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: ImageEntryCodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        _fileName = try values.decodeIfPresent(String.self, forKey: .fileName) ?? ""
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: ImageEntryCodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(fileName, forKey: .fileName)
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
