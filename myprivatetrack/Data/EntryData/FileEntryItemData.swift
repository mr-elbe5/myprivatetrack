//
//  MediaData.swift
//
//  Created by Michael Rönnau on 21.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class FileEntryItemData: EntryItemData{
    
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
