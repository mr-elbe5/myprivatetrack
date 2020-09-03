//
//  PhotoData.swift
//
//  Created by Michael Rönnau on 04.04.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class PhotoData : MediaData{
    
    static let previewSize : CGFloat = 800
    
    private var image : UIImage? = nil
    private var preview : UIImage? = nil
    
    override public var type : EntryItemType{
        get{
            return .photo
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
        let url = FileStore.getURL(dirURL: FileStore.privateURL, fileName: previewName)
        if let data = FileStore.readFile(url: url){
            return UIImage(data: data)
        } else{
            return nil
        }
    }
    
    override func saveImage(uiImage: UIImage?){
        if uiImage != nil{
            super.saveImage(uiImage: uiImage!)
            if !FileStore.fileExists(dirPath: FileStore.privatePath, fileName: previewName){
                let preview = uiImage!.resize(maxWidth: PhotoData.previewSize, maxHeight: PhotoData.previewSize)
                    if let data = preview.jpegData(compressionQuality: 0.8){
                        let url = FileStore.getURL(dirURL: FileStore.privateURL, fileName: previewName)
                        _ = FileStore.saveFile(data: data, url: url)
                    }
                }
            }
        }
    
    override func prepareDelete(){
        super.prepareDelete()
        if FileStore.fileExists(dirPath: FileStore.privatePath, fileName: previewName){
            if !FileStore.deleteFile(dirURL: FileStore.privateURL, fileName: previewName){
                print("error: could not delete file: \(previewName)")
            }
        }
    }
    
    override func isComplete() -> Bool{
        return fileExists()
    }
    
    override func addActiveFileNames( to fileNames: inout Array<String>){
        fileNames.append(fileName)
        fileNames.append(previewName)
    }
    
}
