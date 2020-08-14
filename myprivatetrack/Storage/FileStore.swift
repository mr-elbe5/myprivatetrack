//
//  FileStore.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 22.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct FileStore {
    
    public static var shared = FileStore()
    
    static var privatePath: String = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,.userDomainMask,true).first!
    static var privateUrl : URL = FileManager.default.urls(for: .applicationSupportDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    static var documentPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
    static var documentUrl : URL = FileManager.default.urls(for: .documentDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    static var imageLibraryPath: String = NSSearchPathForDirectoriesInDomains(.picturesDirectory,.userDomainMask,true).first!
    static var imageLibraryUrl : URL = FileManager.default.urls(for: .picturesDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    
    public func initialize() {
        try! FileManager.default.createDirectory(at: FileStore.privateUrl, withIntermediateDirectories: true, attributes: nil)
    }
    
    static func getPath(libPath: String, name: String ) -> String
    {
        return libPath+"/"+name
    }
    
    static func getURL(libUrl: URL, name: String ) -> URL
    {
        return libUrl.appendingPathComponent(name)
    }
    
    func fileExists(libPath: String, fileName: String) -> Bool{
        let path = FileStore.getPath(libPath: libPath,name: fileName)
        return FileManager.default.fileExists(atPath: path)
    }
    
    func readFile(libUrl: URL, fileName: String) -> Data?{
        let filePath = FileStore.getURL(libUrl: libUrl, name: fileName)
        if let fileData = FileManager.default.contents(atPath: filePath.path){
            return fileData
        }
        return nil
    }
    
    func saveFile(data: Data, libUrl: URL, fileName: String){
        let url = FileStore.getURL(libUrl: libUrl, name: fileName)
        do{
            try data.write(to: url, options: .atomic)
        } catch let err{
            print("Error saving file: " + err.localizedDescription)
        }
    }
    
    func renameFile(libUrl: URL, fromName: String, toName: String) -> Bool{
        do{
            try FileManager.default.moveItem(at: FileStore.getURL(libUrl: libUrl, name: fromName),to: FileStore.getURL(libUrl: libUrl, name: toName))
            return true
        }
        catch {
            return false
        }
    }
    
    func deleteFile(libUrl: URL, fileName: String) -> Bool{
        do{
            try FileManager.default.removeItem(at: FileStore.getURL(libUrl: libUrl, name: fileName))
            return true
        }
        catch {
            return false
        }
    }
    
    func saveVideoToLibrary(fileUrl: URL){
        Authorizations.askPhotoLibraryAuthorization(){ result in
            if result{
                PHPhotoLibrary.shared().performChanges({
                    let options = PHAssetResourceCreationOptions()
                    options.shouldMoveFile = true
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .video, fileURL: fileUrl, options: options)
                }, completionHandler: { success, error in
                    if !success {
                        print("Could not save to photo library: \(String(describing: error))")
                    }
                }
                )
            }
            else{
                print("no lib permission")
            }
        }
    }
    
    
    
}
