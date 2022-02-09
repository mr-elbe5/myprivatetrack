/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

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
            return FileController.getPath(dirPath: FileController.privatePath,fileName: fileName)
        }
    }
    
    var fileURL : URL{
        get{
            return FileController.getURL(dirURL: FileController.privateURL,fileName: fileName)
        }
    }
    
    func getFile() -> Data?{
        let url = FileController.getURL(dirURL: FileController.privateURL,fileName: fileName)
        return FileController.readFile(url: url)
    }
    
    func saveFile(data: Data){
        if !FileController.fileExists(dirPath: FileController.privatePath, fileName: fileName){
            let url = FileController.getURL(dirURL: FileController.privateURL,fileName: fileName)
            _ = FileController.saveFile(data: data, url: url)
        }
    }
    
    func fileExists() -> Bool{
        return FileController.fileExists(dirPath: FileController.privatePath, fileName: fileName)
    }
    
    override func prepareDelete(){
        if FileController.fileExists(dirPath: FileController.privatePath, fileName: fileName){
            if !FileController.deleteFile(dirURL: FileController.privateURL, fileName: fileName){
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
