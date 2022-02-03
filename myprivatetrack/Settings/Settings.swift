//
//  Settings.swift
//
//  Created by Michael Rönnau on 03.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Settings: Identifiable, Codable{
    
    static var elbe5Url = "https://maps.elbe5.de/carto/{z}/{x}/{y}.png"
    static var osmUrl = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
    
    static var shared = Settings()
    
    static func load(){
        Settings.shared = DataController.shared.load(forKey: .settings) ?? Settings()
    }
    
    enum CodingKeys: String, CodingKey {
        case osmTemplate
        case mapType
        case showLocation
        case flashMode
        case backgroundName
    }
    
    var osmTemplate : String = elbe5Url
    var mapType : MapType = .apple
    var showLocation = true
    var flashMode : AVCaptureDevice.FlashMode = .off
    var backgroundName : String? = nil
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        osmTemplate = try values.decodeIfPresent(String.self, forKey: .osmTemplate) ?? Settings.elbe5Url
        if let mapTypeName = try values.decodeIfPresent(String.self, forKey: .mapType){
            mapType = MapType(rawValue: mapTypeName) ?? .apple
        }
        showLocation = try values.decodeIfPresent(Bool.self, forKey: .showLocation) ?? true
        if let flashModeIdx = try values.decodeIfPresent(Int.self, forKey: .flashMode){
            flashMode = AVCaptureDevice.FlashMode(rawValue: flashModeIdx) ?? .off
        }
        do{
            backgroundName = try values.decodeIfPresent(String.self, forKey: .backgroundName)
        } catch{
            backgroundName = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(osmTemplate, forKey: .osmTemplate)
        try container.encode(mapType.rawValue, forKey: .mapType)
        try container.encode(showLocation, forKey: .showLocation)
        try container.encode(flashMode.rawValue, forKey: .flashMode)
        try container.encode(backgroundName, forKey: .backgroundName)
    }
    
    func save(){
        DataController.shared.save(forKey: .settings, value: self)
    }
    
    var backgroundImage : UIImage?{
        get{
            if let name = backgroundName{
                let url = FileController.getURL(dirURL: FileController.privateURL, fileName: name)
                if FileController.fileExists(url: url){
                    if let data = FileController.readFile(url: url){
                        return UIImage(data: data)
                    }
                }
            }
            return UIImage(named: "meersonne")
        }
    }
}
