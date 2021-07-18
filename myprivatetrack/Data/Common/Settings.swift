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
    
    static var shared = Settings()
    
    static func load(){
        Settings.shared = DataController.shared.load(forKey: .settings) ?? Settings()
    }
    
    enum CodingKeys: String, CodingKey {
        case saveLocation
        case flashMode
        case mapStartZoom
        case backgroundName
    }
    
    var saveLocation = true
    var flashMode : AVCaptureDevice.FlashMode = .off
    var mapStartZoom : CGFloat = Statics.zoomDefault
    var backgroundName : String? = nil
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        saveLocation = try values.decodeIfPresent(Bool.self, forKey: .saveLocation) ?? true
        flashMode = AVCaptureDevice.FlashMode(rawValue: try values.decode(Int.self, forKey: .flashMode)) ?? .off
        mapStartZoom = try values.decodeIfPresent(CGFloat.self, forKey: .mapStartZoom) ?? Statics.zoomDefault
        do{
            backgroundName = try values.decode(String.self, forKey: .backgroundName)
        } catch{
            backgroundName = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(saveLocation, forKey: .saveLocation)
        try container.encode(flashMode.rawValue, forKey: .flashMode)
        try container.encode(mapStartZoom, forKey: .mapStartZoom)
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
