/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import CoreLocation
import UIKit

class EntryData: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case id
        case creationDate
        case location
        case locationDescription
        case showLocation
        case hasMapSection //deprecated
        case mapComment //deprecated
        case items
    }
    
    var id: UUID
    var creationDate: Date
    var location: Location? = nil
    var locationDescription: String = ""
    var showLocation: Bool
    var items : Array<EntryItem>
    
    var isNew = false
    
    init(isNew: Bool = false){
        self.isNew = isNew
        id = UUID()
        creationDate = Date()
        location = nil
        showLocation = Settings.shared.showLocation
        items = Array<EntryItem>()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        creationDate = try values.decodeIfPresent(Date.self, forKey: .creationDate) ?? Date()
        location = try values.decodeIfPresent(Location.self, forKey: .location)
        locationDescription = try values.decodeIfPresent(String.self, forKey: .locationDescription) ?? ""
        showLocation = try values.decodeIfPresent(Bool.self, forKey: .showLocation) ?? true
        items = try values.decodeIfPresent(Array<EntryItem>.self, forKey: .items) ?? Array<EntryItem>()
        //backward compatibility
        if let hasMapSection = try values.decodeIfPresent(Bool.self, forKey: .hasMapSection), hasMapSection{
            showLocation = true
            let mapComment = try values.decodeIfPresent(String.self, forKey: .mapComment)
            createMapEntryFromSection(comment: mapComment)
        }
    }
    
    private func createMapEntryFromSection(comment: String? = nil){
        let fileName = id.uuidString + "_map.jpg"
        let fileUrl = FileController.getURL(dirURL: FileController.privateURL,fileName: fileName)
        if FileController.fileExists(url: fileUrl){
            print("creating image item from map")
            let imageItem = ImageItemData()
            imageItem.creationDate = creationDate
            imageItem.fileName = fileName
            imageItem.title = comment ?? ""
            addItem(item: imageItem)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(showLocation, forKey: .showLocation)
        if let loc = location{
            try container.encode(loc, forKey: .location)
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
