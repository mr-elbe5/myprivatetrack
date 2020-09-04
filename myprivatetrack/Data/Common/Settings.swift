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
    
    public static var shared = Settings()
    
    public static func load(){
        Settings.shared = DataStore.shared.load(forKey: .settings) ?? Settings()
    }
    
    enum CodingKeys: String, CodingKey {
        case saveLocation
        case flashMode
        case mapStartSize
        case backgroundName
    }
    
    var saveLocation = true
    var flashMode : AVCaptureDevice.FlashMode = .off
    var mapStartSize : MapStartSize = .mid
    var backgroundName : String? = nil
    
    var mapStartSizeIndex : Int{
        get{
            switch mapStartSize{
            case .small:
                return 0
            case .mid:
                return 1
            case .large:
                return 2
            }
        }
    }
    
    init(){
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        saveLocation = try values.decode(Bool.self, forKey: .saveLocation)
        flashMode = AVCaptureDevice.FlashMode(rawValue: try values.decode(Int.self, forKey: .flashMode)) ?? .off
        mapStartSize = MapStartSize(rawValue: try values.decode(Double.self, forKey: .mapStartSize)) ?? MapStartSize.mid
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
        try container.encode(Double(mapStartSize.rawValue), forKey: .mapStartSize)
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
