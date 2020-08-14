//
//  MediaData.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 21.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class MediaData: EntryItemData{
    
    enum MediaCodingKeys: String, CodingKey {
        case title
    }
    
    public var title: String
    
    var fileName : String {
        get{
            return id.uuidString
        }
    }
    
    var filePath : String{
        get{
            return FileStore.getPath(libPath: FileStore.privatePath, name: fileName)
        }
    }
    
    var fileURL : URL{
        get{
            return FileStore.getURL(libUrl: FileStore.privateUrl, name: fileName)
        }
    }
    
    override init(){
        title = ""
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: MediaCodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: MediaCodingKeys.self)
        try container.encode(title, forKey: .title)
    }
    
    func getFile() -> Data?{
        return FileStore.shared.readFile(libUrl: FileStore.privateUrl, fileName: fileName)
    }
    
    func getImage() -> UIImage?{
        if let data = getFile(){
            return UIImage(data: data)
        } else{
            return nil
        }
    }
    
    func saveFile(data: Data){
        if !FileStore.shared.fileExists(libPath: FileStore.privatePath, fileName: fileName){
            FileStore.shared.saveFile(data: data, libUrl: FileStore.privateUrl, fileName: fileName)
        }
    }
    
    func saveImage(uiImage: UIImage){
        if let data = uiImage.jpegData(compressionQuality: 0.8){
            saveFile(data: data)
        }
    }
    
    func deleteFiles() -> Bool{
        var success = true
        if FileStore.shared.fileExists(libPath: FileStore.privatePath, fileName: fileName){
            success = success && FileStore.shared.deleteFile(libUrl: FileStore.privateUrl, fileName: fileName)
        }
        return success
    }
    
    func fileExists() -> Bool{
        return FileStore.shared.fileExists(libPath: FileStore.privatePath, fileName: fileName)
    }
    
}
