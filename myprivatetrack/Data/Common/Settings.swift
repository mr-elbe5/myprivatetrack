//
//  Settings.swift
//
//  Created by Michael Rönnau on 03.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class Settings: Identifiable, Codable{
    
    public static var shared = Settings()
    
    public static func load(){
        shared = DataStore.shared.load(forKey: .settings) ?? Settings()
    }
    
    enum CodingKeys: String, CodingKey {
        case saveLocation
        case mapStartSize
        case imageMaxSide
        case backgroundName
    }
    
    var saveLocation = false
    var mapStartSize : MapStartSize = .mid
    var imageMaxSide : ImageMaxSide = .mid
    var backgroundName : String? = nil
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        saveLocation = try values.decode(Bool.self, forKey: .saveLocation)
        mapStartSize = MapStartSize(rawValue: try values.decode(Int.self, forKey: .mapStartSize))!
        imageMaxSide = ImageMaxSide(rawValue: try values.decode(Int.self, forKey: .imageMaxSide))!
        backgroundName = try values.decode(String.self, forKey: .backgroundName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(saveLocation, forKey: .saveLocation)
        try container.encode(mapStartSize.rawValue, forKey: .mapStartSize)
        try container.encode(imageMaxSide.rawValue, forKey: .imageMaxSide)
        try container.encode(backgroundName, forKey: .backgroundName)
    }
    
    func save(){
        DataStore.shared.save(forKey: .settings, value: self)
    }
    
    var backgroundImage : UIImage?{
        get{
            if let name = backgroundName{
                let url = FileStore.getURL(dirURL: FileStore.privateURL, fileName: name)
                if FileStore.fileExists(url: url){
                    if let data = FileStore.readFile(url: url){
                        return UIImage(data: data)
                    }
                }
            }
            return UIImage(named: "meersonne")
        }
    }
}
