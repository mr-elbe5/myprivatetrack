//
//  EntryItemData.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 12.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

enum EntryItemType{
    case none
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
    
    func addToEntry(entry: EntryData){
        fatalError("not implemented")
    }
    
    func removeFromEntry(entry: EntryData){
        fatalError("not implemented")
    }
    
    func isComplete() -> Bool{
        return true
    }
    
}
