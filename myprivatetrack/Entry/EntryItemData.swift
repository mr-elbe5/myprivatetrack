/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

enum EntryItemType: String, Codable{
    case text
    case audio
    case photo
    case image
    case video
}

class EntryItemData: Identifiable, Codable{
    
    private enum EntryItemCodingKeys: CodingKey{
        case id
        case creationDate
    }
    
    var id: UUID
    var creationDate: Date
    
    var isNew = false
    
    var type : EntryItemType{
        get{
            return .text
        }
    }
    
    init(isNew: Bool = false){
        self.isNew = isNew
        id = UUID()
        creationDate = Date()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: EntryItemCodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        creationDate = try values.decodeIfPresent(Date.self, forKey: .creationDate) ?? Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: EntryItemCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creationDate, forKey: .creationDate)
    }
    
    func prepareDelete(){
    }
    
    func isComplete() -> Bool{
        return true
    }
    
    func addActiveFileNames( to fileNames: inout Array<String>){
    }
    
}

class EntryItem : Identifiable, Codable{
    
    private enum CodingKeys: CodingKey{
        case type
        case item
    }
    
    var type : EntryItemType
    var data : EntryItemData
    
    init(item: EntryItemData){
        self.type = item.type
        self.data = item
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(EntryItemType.self, forKey: .type)
        switch type{
        case .text:
            data = try values.decode(TextItemData.self, forKey: .item)
            break
        case .audio:
            data = try values.decode(AudioData.self, forKey: .item)
            break
        case .photo:
            data = try values.decode(PhotoItemData.self, forKey: .item)
            break
        case .image:
            data = try values.decode(ImageItemData.self, forKey: .item)
            break
        case .video:
            data = try values.decode(VideoItemData.self, forKey: .item)
            break
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(data, forKey: .item)
    }
    
    func addActiveFileNames( to fileNames: inout Array<String>){
        data.addActiveFileNames(to: &fileNames)
    }
    
}
