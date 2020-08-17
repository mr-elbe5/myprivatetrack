//
//  Settings.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 03.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class Settings: Identifiable, Codable{
    
    enum CodingKeys: String, CodingKey {
        case startDate
        case endDate
        case useLocation
        case mapZoomLevel
        case startAtCurrentLocation
        case lastLatitude
        case lastLongitude
        case resizeImages
        case resizeScale
    }
    
    enum ResizeScale: Int {
        case small = 1024
        case mid = 2048
        case large = 4096
    }
    
    var startDate : Date? = nil
    var endDate : Date? = nil
    var useLocation = true
    var mapZoomLevel = 16
    var startAtCurrentLocation = true
    var lastLatitude : Double = 0.0
    var lastLongitude : Double = 0.0
    var resizeImages = true
    var resizeScale : ResizeScale = .small
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        startDate = try values.decode(Date.self, forKey: .startDate)
        endDate = try values.decode(Date.self, forKey: .endDate)
        useLocation = try values.decode(Bool.self, forKey: .useLocation)
        mapZoomLevel = try values.decode(Int.self, forKey: .mapZoomLevel)
        startAtCurrentLocation = try values.decode(Bool.self, forKey: .startAtCurrentLocation)
        lastLatitude = try values.decode(Double.self, forKey: .lastLatitude)
        lastLongitude = try values.decode(Double.self, forKey: .lastLongitude)
        resizeImages = try values.decode(Bool.self, forKey: .resizeImages)
        resizeScale = ResizeScale(rawValue: try values.decode(Int.self, forKey: .resizeScale))!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(useLocation, forKey: .useLocation)
        try container.encode(mapZoomLevel, forKey: .mapZoomLevel)
        try container.encode(startAtCurrentLocation, forKey: .startAtCurrentLocation)
        try container.encode(lastLatitude, forKey: .lastLatitude)
        try container.encode(lastLongitude, forKey: .lastLongitude)
        try container.encode(resizeImages, forKey: .resizeImages)
        try container.encode(resizeScale.rawValue, forKey: .resizeScale)
    }
    
    func save(){
        DataStore.shared.saveSettings()
    }
    
}
