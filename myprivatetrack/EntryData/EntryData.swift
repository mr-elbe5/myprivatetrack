//
//  EntryData.swift
//
//  Created by Michael Rönnau on 06.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation

class EntryData: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case id
        case creationDate
        case location
        case saveLocation
        case items
    }
    
    public var id: UUID
    public var creationDate: Date
    public var location: Location
    public var saveLocation: Bool
    public var items = Array<EntryItem>()
    
    public var isNew = false
    
    init(isNew: Bool = false){
        self.isNew = isNew
        id = UUID()
        creationDate = Date()
        location = Location()
        saveLocation = true
        items = []
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
        saveLocation = try values.decode(Bool.self, forKey: .saveLocation)
        if saveLocation{
            location = try values.decode(Location.self, forKey: .location)
        }else{
            location = Location()
        }
        items = try values.decode(Array<EntryItem>.self, forKey: .items)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(saveLocation, forKey: .saveLocation)
        if saveLocation{
            try container.encode(location, forKey: .location)
        }
        try container.encode(items, forKey: .items)
    }
    
    func addItem(item : EntryItemData){
        items.append(EntryItem(item: item))
    }
    
    func removeItem(item: EntryItemData){
        item.prepareDelete()
        for i in 0..<items.count{
            if items[i].data.id == item.id{
                items.remove(at: i)
                break
            }
        }
    }
    
    func removeAllItems(){
        prepareDeleteItems()
        items.removeAll()
    }
    
    func prepareDeleteItems(){
        for item in items{
            item.data.prepareDelete()
        }
    }
    
    func isComplete()-> Bool{
        for item in items{
            if !item.data.isComplete(){
                return false
            }
        }
        return true
    }
    
    func addActiveFileNames( to fileNames: inout Array<String>){
        for item in items{
            item.addActiveFileNames(to: &fileNames)
        }
    }
    
}
