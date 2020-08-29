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
    
    public var title: String = ""
    
    var fileName : String {
        get{
            return id.uuidString
        }
    }
    
    var filePath : String{
        get{
            return FileStore.getPath(dirPath: FileStore.privatePath,fileName: fileName)
        }
    }
    
    var fileURL : URL{
        get{
            return FileStore.getURL(dirURL: FileStore.privateURL,fileName: fileName)
        }
    }
    
    init(){
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
        let url = FileStore.getURL(dirURL: FileStore.privateURL,fileName: fileName)
        return FileStore.readFile(url: url)
    }
    
    func getImage() -> UIImage?{
        if let data = getFile(){
            return UIImage(data: data)
        } else{
            return nil
        }
    }
    
    func saveFile(data: Data){
        if !FileStore.fileExists(dirPath: FileStore.privatePath, fileName: fileName){
            let url = FileStore.getURL(dirURL: FileStore.privateURL,fileName: fileName)
            _ = FileStore.saveFile(data: data, url: url)
        }
    }
    
    func saveImage(uiImage: UIImage){
        if let data = uiImage.jpegData(compressionQuality: 0.8){
            saveFile(data: data)
        }
    }
    
    func fileExists() -> Bool{
        return FileStore.fileExists(dirPath: FileStore.privatePath, fileName: fileName)
    }
    
    override func prepareDelete(){
        if FileStore.fileExists(dirPath: FileStore.privatePath, fileName: fileName){
            if !FileStore.deleteFile(dirURL: FileStore.privateURL, fileName: fileName){
                print("error: could not delete file: \(fileName)")
            }
        }
    }
    
}
