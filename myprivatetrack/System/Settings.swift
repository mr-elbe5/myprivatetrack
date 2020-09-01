//
//  Settings.swift
//
//  Created by Michael Rönnau on 03.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

enum MapStartSize: Int{
    case small = 100
    case mid = 5000
    case large = 20000
}

enum ImageMaxSide: Int{
    case small = 1024
    case mid = 20148
    case large = 4096
}

class Settings: Identifiable, Codable{
    
    public static var shared = Settings()
    
    public static func load(){
        shared = DataStore.shared.load(forKey: .settings) ?? Settings()
    }
    
    enum CodingKeys: String, CodingKey {
        case saveLocation
        case mapStartSize
        case imageMaxSide
        case backgroundURL
    }
    
    var saveLocation = false
    var mapStartSize : MapStartSize = .mid
    var imageMaxSide : ImageMaxSide = .mid
    var backgroundURL : URL? = nil
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        saveLocation = try values.decode(Bool.self, forKey: .saveLocation)
        mapStartSize = MapStartSize(rawValue: try values.decode(Int.self, forKey: .mapStartSize))!
        imageMaxSide = ImageMaxSide(rawValue: try values.decode(Int.self, forKey: .imageMaxSide))!
        backgroundURL = try values.decode(URL.self, forKey: .backgroundURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(saveLocation, forKey: .saveLocation)
        try container.encode(mapStartSize.rawValue, forKey: .mapStartSize)
        try container.encode(imageMaxSide.rawValue, forKey: .imageMaxSide)
        try container.encode(backgroundURL, forKey: .backgroundURL)
    }
    
    func save(){
        DataStore.shared.save(forKey: .settings, value: self)
    }
    
    var backgroundImage : UIImage?{
        get{
            if let url = backgroundURL{
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
