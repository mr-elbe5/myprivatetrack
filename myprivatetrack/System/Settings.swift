//
//  Settings.swift
//
//  Created by Michael Rönnau on 03.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

enum MapStartSize: Int{
    case small = 500
    case mid = 1000
    case large = 4000
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
        case useLocation
        case mapStartSize
        case imageMaxSide
    }
    
    var useLocation = true
    var mapStartSize : MapStartSize = .mid
    var imageMaxSide : ImageMaxSide = .mid
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        useLocation = try values.decode(Bool.self, forKey: .useLocation)
        mapStartSize = MapStartSize(rawValue: try values.decode(Int.self, forKey: .mapStartSize))!
        imageMaxSide = ImageMaxSide(rawValue: try values.decode(Int.self, forKey: .imageMaxSide))!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(useLocation, forKey: .useLocation)
        try container.encode(mapStartSize.rawValue, forKey: .mapStartSize)
        try container.encode(imageMaxSide.rawValue, forKey: .imageMaxSide)
    }
    
    func save(){
        DataStore.shared.save(forKey: .settings, value: self)
    }
    
}
