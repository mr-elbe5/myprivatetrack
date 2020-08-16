//
//  EntryItemData.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 12.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

enum EntryItemType: String, Codable{
    case text
    case audio
    case image
    case video
    case location
}

class EntryItemData: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case id
        case creationDate
    }
    
    public var id: UUID
    public var creationDate: Date
    
    public var type : EntryItemType{
        get{
            return .text
        }
    }
    
    init(){
        id = UUID()
        creationDate = Date()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creationDate, forKey: .creationDate)
    }
    
    func prepareDelete(){
    }
    
    func isComplete() -> Bool{
        return true
    }
    
}

class EntryItem : Codable{
    
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
            data = try values.decode(TextData.self, forKey: .item)
            break
        case .audio:
            data = try values.decode(AudioData.self, forKey: .item)
            break
        case .image:
            data = try values.decode(ImageData.self, forKey: .item)
            break
        case .video:
            data = try values.decode(VideoData.self, forKey: .item)
            break
        case .location:
            data = try values.decode(LocationData.self, forKey: .item)
            break
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(data, forKey: .item)
    }
    
}
