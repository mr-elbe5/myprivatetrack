//
//  EntryItemData.swift
//
//  Created by Michael Rönnau on 12.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

enum EntryItemType: String, Codable{
    case text
    case audio
    case photo
    case video
    case map
}

class EntryItemData: Identifiable, Codable{
    
    public var id: UUID
    public var creationDate: Date
    
    public var isNew = false
    
    public var type : EntryItemType{
        get{
            return .text
        }
    }
    
    public init(isNew: Bool = false){
        self.isNew = isNew
        id = UUID()
        creationDate = Date()
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
        case id
        case creationDate
        case type
        case item
    }
    
    var id: UUID
    var creationDate: Date
    var type : EntryItemType
    var data : EntryItemData
    
    init(item: EntryItemData){
        id = UUID()
        creationDate = Date()
        self.type = item.type
        self.data = item
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
        type = try values.decode(EntryItemType.self, forKey: .type)
        switch type{
        case .text:
            data = try values.decode(TextData.self, forKey: .item)
            break
        case .audio:
            data = try values.decode(AudioData.self, forKey: .item)
            break
        case .photo:
            data = try values.decode(PhotoData.self, forKey: .item)
            break
        case .video:
            data = try values.decode(VideoData.self, forKey: .item)
            break
        case .map:
            data = try values.decode(MapData.self, forKey: .item)
            break
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(type, forKey: .type)
        try container.encode(data, forKey: .item)
    }
    
    func addActiveFileNames( to fileNames: inout Array<String>){
        data.addActiveFileNames(to: &fileNames)
    }
    
}
