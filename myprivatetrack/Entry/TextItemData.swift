/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class TextItemData: EntryItemData{
    
    enum TextCodingKeys: String, CodingKey {
        case text
    }
    
    override var type : EntryItemType{
        get{
            return .text
        }
    }
    
    var text: String
    
    init(){
        text = ""
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TextCodingKeys.self)
        text = try values.decodeIfPresent(String.self, forKey: .text) ?? ""
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: TextCodingKeys.self)
        try container.encode(text, forKey: .text)
    }
    
    override func isComplete() -> Bool{
        return text.count > 0
    }
    
}
