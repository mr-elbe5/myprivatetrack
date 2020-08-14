//
//  ImageData.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 04.04.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class ImageData : MediaData{
    
    static let previewSize : CGFloat = 800
    
    private var image : UIImage? = nil
    private var preview : UIImage? = nil
    
    override public var type : EntryItemType{
        get{
            return .image
        }
    }
    
    override var fileName : String {
        get{
            return "img_\(creationDate.fileDate()).jpg"
        }
    }
    
    var previewName : String {
        get{
            return "preview_\(creationDate.fileDate()).jpg"
        }
    }
    
    func getPreview() -> UIImage?{
        if let data = FileStore.shared.readFile(libUrl: FileStore.privateUrl, fileName: previewName){
            return UIImage(data: data)
        } else{
            return nil
        }
    }
    
    override func saveImage(uiImage: UIImage?){
        if uiImage != nil{
            super.saveImage(uiImage: uiImage!)
            if !FileStore.shared.fileExists(libPath: FileStore.privatePath, fileName: previewName){
                let preview = uiImage!.resize(maxWidth: ImageData.previewSize, maxHeight: ImageData.previewSize)
                    if let data = preview.jpegData(compressionQuality: 0.8){
                        FileStore.shared.saveFile(data: data, libUrl: FileStore.privateUrl, fileName: previewName)
                    }
                }
            }
        }
    
    override func deleteFiles() -> Bool{
        var success = true
        if FileStore.shared.fileExists(libPath: FileStore.privatePath, fileName: fileName){
            success = success && FileStore.shared.deleteFile(libUrl: FileStore.privateUrl, fileName: fileName)
        }
        if FileStore.shared.fileExists(libPath: FileStore.privatePath, fileName: previewName){
            success = success && FileStore.shared.deleteFile(libUrl: FileStore.privateUrl, fileName: previewName)
        }
        return success
    }
    
    override func addToEntry(entry: EntryData){
        entry.addImage(entry: self)
    }
    
    override func removeFromEntry(entry: EntryData){
        _ = deleteFiles()
        entry.removeImage(entry: self)
    }
    
    override func isComplete() -> Bool{
        return fileExists()
    }
    
}
