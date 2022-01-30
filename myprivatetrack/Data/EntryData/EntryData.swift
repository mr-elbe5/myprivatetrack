//
//  EntryData.swift
//
//  Created by Michael Rönnau on 06.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class EntryData: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case id
        case creationDate
        case location
        case locationDescription
        case saveLocation
        case hasMapSection //deprecated
        case mapComment //deprecated
        case items
    }
    
    var id: UUID
    var creationDate: Date
    var location: Location? = nil
    var locationDescription: String = ""
    var saveLocation: Bool
    var items = Array<EntryItem>()
    
    var isNew = false
    
    var mapSectionFileName : String{
        get{
            return id.uuidString + "_map.jpg"
        }
    }
    
    var mapSectionFileURL : URL{
        get{
            return FileController.getURL(dirURL: FileController.privateURL,fileName: mapSectionFileName)
        }
    }
    
    init(isNew: Bool = false){
        self.isNew = isNew
        id = UUID()
        creationDate = Date()
        location = nil
        saveLocation = Settings.shared.showLocation
        items = []
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
        saveLocation = try values.decode(Bool.self, forKey: .saveLocation)
        if saveLocation{
            location = try values.decode(Location.self, forKey: .location)
            locationDescription = try values.decode(String.self, forKey: .locationDescription)
        }else{
            location = nil
            locationDescription = ""
        }
        items = try values.decode(Array<EntryItem>.self, forKey: .items)
        let hasMapSection = try values.decodeIfPresent(Bool.self, forKey: .hasMapSection) ?? false
        if hasMapSection{
            let mapComment = try values.decodeIfPresent(String.self, forKey: .mapComment)
            if createMapEntryFromSection(comment: mapComment){
                
            }
        }
    }
    
    private func createMapEntryFromSection(comment: String? = nil) -> Bool{
        let oldFileUrl = FileController.getURL(dirURL: FileController.privateURL,fileName: id.uuidString + "_map.jpg")
        if let data = FileController.readFile(url: oldFileUrl), let image = UIImage(data: data){
            print("creating map item")
            let mapItem = MapPhotoItemData()
            mapItem.creationDate = creationDate
            mapItem.saveImage(uiImage: image)
            mapItem.title = comment ?? ""
            FileController.deleteFile(url: oldFileUrl)
            addItem(item: mapItem)
            return true
        }
        return false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(saveLocation, forKey: .saveLocation)
        if saveLocation{
            try container.encode(location, forKey: .location)
            try container.encode(locationDescription, forKey: .locationDescription)
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
