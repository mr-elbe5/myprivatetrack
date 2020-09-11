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
        case hasMapSection
        case items
    }
    
    public var id: UUID
    public var creationDate: Date
    public var location: Location? = nil
    public var locationDescription: String = ""
    public var saveLocation: Bool
    public var hasMapSection: Bool = false
    public var items = Array<EntryItem>()
    
    public var isNew = false
    
    public var mapSectionFileName : String{
        get{
            return id.uuidString + "_map.jpg"
        }
    }
    
    public var mapSectionFileURL : URL{
        get{
            return FileController.getURL(dirURL: FileController.privateURL,fileName: mapSectionFileName)
        }
    }
    
    init(isNew: Bool = false){
        self.isNew = isNew
        id = UUID()
        creationDate = Date()
        location = nil
        saveLocation = Settings.shared.saveLocation
        items = []
    }
    
    func hasMapSectionFile() -> Bool{
        return hasMapSection && FileController.fileExists(url: mapSectionFileURL)
    }
    
    func getMapSection() -> UIImage?{
        if hasMapSection{
            if let data = FileController.readFile(url: mapSectionFileURL){
                return UIImage(data: data)
            }
        }
        return nil
    }
    
    func saveMapSection(uiImage: UIImage) -> Bool{
        hasMapSection = false
        let url = FileController.getURL(dirURL: FileController.privateURL,fileName: mapSectionFileName)
        if FileController.fileExists(url: url){
            _ = FileController.deleteFile(url: url)
        }
        if let data = uiImage.jpegData(compressionQuality: 0.8){
            if FileController.saveFile(data: data, url: url){
                hasMapSection = true
                return true
            }
        }
        return false
    }
    
    public func deleteMapSection(){
        _ = FileController.deleteFile(url: mapSectionFileURL)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        creationDate = try values.decode(Date.self, forKey: .creationDate)
        saveLocation = try values.decode(Bool.self, forKey: .saveLocation)
        if saveLocation{
            location = try values.decode(Location.self, forKey: .location)
            locationDescription = try values.decode(String.self, forKey: .locationDescription)
            hasMapSection = try values.decode(Bool.self, forKey: .hasMapSection)
        }else{
            location = nil
            locationDescription = ""
            hasMapSection = false
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
            try container.encode(locationDescription, forKey: .locationDescription)
            try container.encode(hasMapSection, forKey: .hasMapSection)
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
        if hasMapSectionFile(){
            fileNames.append(mapSectionFileName)
        }
        for item in items{
            item.addActiveFileNames(to: &fileNames)
        }
    }
    
}
