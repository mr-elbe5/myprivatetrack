//
//  MediaData.swift
//
//  Created by Michael Rönnau on 21.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class FileEntryItemData: EntryItemData{
    
    enum FileEntryCodingKeys: String, CodingKey {
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
        let values = try decoder.container(keyedBy: FileEntryCodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: FileEntryCodingKeys.self)
        try container.encode(title, forKey: .title)
    }
    
    func getFile() -> Data?{
        let url = FileStore.getURL(dirURL: FileStore.privateURL,fileName: fileName)
        return FileStore.readFile(url: url)
    }
    
    func saveFile(data: Data){
        if !FileStore.fileExists(dirPath: FileStore.privatePath, fileName: fileName){
            let url = FileStore.getURL(dirURL: FileStore.privateURL,fileName: fileName)
            _ = FileStore.saveFile(data: data, url: url)
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
    
    override func isComplete() -> Bool{
        return fileExists()
    }
    
    override func addActiveFileNames( to fileNames: inout Array<String>){
        fileNames.append(fileName)
    }
    
}
