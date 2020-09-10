//
//  FileStore.swift
//
//  Created by Michael Rönnau on 22.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import Photos
import Compression
import Zip

public class FileStore {
    
    public static var shared = FileStore()
    
    static let tempDir = NSTemporaryDirectory()
    
    static public var privatePath: String = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,.userDomainMask,true).first!
    static public var privateURL : URL = FileManager.default.urls(for: .applicationSupportDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    static public var documentPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true).first!
    static public var documentURL : URL = FileManager.default.urls(for: .documentDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    static public var backupDirURL = documentURL.appendingPathComponent(Statics.backupDir)
    static public var exportDirURL = documentURL.appendingPathComponent(Statics.exportDir)
    static public var imageLibraryPath: String = NSSearchPathForDirectoriesInDomains(.picturesDirectory,.userDomainMask,true).first!
    static public var imageLibraryURL : URL = FileManager.default.urls(for: .picturesDirectory,in: FileManager.SearchPathDomainMask.userDomainMask).first!
    static public var temporaryPath : String {
        get{
            return tempDir
        }
    }
    static public var temporaryURL : URL{
        get{
            return URL(fileURLWithPath: temporaryPath, isDirectory: true)
        }
    }
    
    static public func initialize() {
        try! FileManager.default.createDirectory(at: privateURL, withIntermediateDirectories: true, attributes: nil)
        try! FileManager.default.createDirectory(at: backupDirURL, withIntermediateDirectories: true, attributes: nil)
        try! FileManager.default.createDirectory(at: exportDirURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    static public func getPath(dirPath: String, fileName: String ) -> String
    {
        return dirPath+"/"+fileName
    }
    
    static public func getURL(dirURL: URL, fileName: String ) -> URL
    {
        return dirURL.appendingPathComponent(fileName)
    }
    
    static public func fileExists(dirPath: String, fileName: String) -> Bool{
        let path = getPath(dirPath: dirPath,fileName: fileName)
        return FileManager.default.fileExists(atPath: path)
    }
    
    static public func fileExists(url: URL) -> Bool{
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    static public func readFile(url: URL) -> Data?{
        if let fileData = FileManager.default.contents(atPath: url.path){
            return fileData
        }
        return nil
    }
    
    static public func readTextFile(url: URL) -> String?{
        do{
            let string = try String(contentsOf: url, encoding: .utf8)
            return string
        }
        catch{
            return nil
        }
    }
    
    static public func saveFile(data: Data, url: URL) -> Bool{
        do{
            try data.write(to: url, options: .atomic)
            return true
        } catch let err{
            print("Error saving file: " + err.localizedDescription)
            return false
        }
    }
    
    static public func saveFile(text: String, url: URL) -> Bool{
        do{
            try text.write(to: url, atomically: true, encoding: .utf8)
            return true
        } catch let err{
            print("Error saving file: " + err.localizedDescription)
            return false
        }
    }
    
    static public func copyFile(name: String,fromDir: URL, toDir: URL, replace: Bool = false) -> Bool{
        do{
            if replace && fileExists(url: getURL(dirURL: toDir, fileName: name)){
                _ = deleteFile(url: getURL(dirURL: toDir, fileName: name))
            }
            try FileManager.default.copyItem(at: getURL(dirURL: fromDir,fileName: name), to: getURL(dirURL: toDir, fileName: name))
            return true
        } catch let err{
            print("Error copying file: " + err.localizedDescription)
            return false
        }
    }
    
    static public func copyFile(fromURL: URL, toURL: URL, replace: Bool = false) -> Bool{
        do{
            if replace && fileExists(url: toURL){
                _ = deleteFile(url: toURL)
            }
            try FileManager.default.copyItem(at: fromURL, to: toURL)
            return true
        } catch let err{
            print("Error copying file: " + err.localizedDescription)
            return false
        }
    }
    
    public static func askPhotoLibraryAuthorization(callback: @escaping (Result<Void, Error>) -> Void){
        switch PHPhotoLibrary.authorizationStatus(){
        case .authorized:
            callback(.success(()))
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(){ granted in
                if granted == .authorized{
                    callback(.success(()))
                }
                else{
                    callback(.failure(AuthorizationError.rejected))
                }
            }
            break
        default:
            callback(.failure(AuthorizationError.rejected))
            break
        }
    }
    
    static func copyImageToLibrary(name: String, fromDir: URL, callback: @escaping (Result<Void, FileError>) -> Void){
        askPhotoLibraryAuthorization(){ result in
            switch result{
            case .success(()):
                let url = getURL(dirURL: fromDir, fileName: name)
                if let data = readFile(url: url){
                    if let image = UIImage(data: data){
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        callback(.success(()))
                        return
                    }
                    else{
                        callback(.failure(.save))
                        return
                    }
                }
                else{
                    callback(.failure(.read))
                }
                break
            case .failure:
                callback(.failure(.unauthorized))
            }
        }
    }
    
    static func copyImageFromLibrary(name: String, fromDir: URL, callback: @escaping ( Result<Void, FileError>) -> Void){
        askPhotoLibraryAuthorization(){ result in
            switch result{
            case .success(()):
                let url = getURL(dirURL: fromDir, fileName: name)
                if let data = readFile(url: url){
                    if let image = UIImage(data: data){
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        callback(.success(()))
                        return
                    }
                    else{
                        callback(.failure(.save))
                        return
                    }
                }
                else{
                    callback(.failure(.read))
                }
                break
            case .failure:
                callback(.failure(.unauthorized))
            }
        }
    }
    
    static func copyVideoToLibrary(name: String, fromDir: URL, callback: @escaping (Result<Void, FileError>) -> Void){
        askPhotoLibraryAuthorization(){ result in
            switch result{
            case .success(()):
                let url = getURL(dirURL: fromDir, fileName: name)
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                }) { saved, error in
                    if saved {
                        print("video saved")
                        callback(.success(()))
                        return
                    }
                    else{
                        callback(.failure(.save))
                        return
                    }
                }
                return
            case .failure:
                callback(.failure(.unauthorized))
                return
            }
        }
    }
    
    static public func renameFile(dirURL: URL, fromName: String, toName: String) -> Bool{
        do{
            try FileManager.default.moveItem(at: getURL(dirURL: dirURL, fileName: fromName),to: getURL(dirURL: dirURL, fileName: toName))
            return true
        }
        catch {
            return false
        }
    }
    
    static public func deleteFile(dirURL: URL, fileName: String) -> Bool{
        do{
            try FileManager.default.removeItem(at: getURL(dirURL: dirURL, fileName: fileName))
            print("file deleted: \(fileName)")
            return true
        }
        catch {
            return false
        }
    }
    
    static public func deleteFile(url: URL) -> Bool{
        do{
            try FileManager.default.removeItem(at: url)
            print("file deleted: \(url)")
            return true
        }
        catch {
            return false
        }
    }
    
    static public func listAllFiles(dirPath: String) -> Array<String>{
        return try! FileManager.default.contentsOfDirectory(atPath: dirPath)
    }
    
    static public func listAllURLs(dirURL: URL) -> Array<URL>{
        let names = listAllFiles(dirPath: dirURL.path)
        var urls = Array<URL>()
        for name in names{
            urls.append(getURL(dirURL: dirURL, fileName: name))
        }
        return urls
    }
    
    static public func deleteAllFiles(dirURL: URL){
        let names = listAllFiles(dirPath: dirURL.path)
        var count = 0
        for name in names{
            if deleteFile(dirURL: dirURL, fileName: name){
                count += 1
            }
        }
        print("\(count) files deleted")
    }
    
    static public func zipFiles(sourceFiles: [URL], zipURL: URL){
        do {
            try Zip.zipFiles(paths: sourceFiles, zipFilePath: zipURL, password: nil, progress: { (progress) -> () in
                print(progress)
            })
        }
        catch {
          print("Could not zip files")
        }
    }
    
    static public func unzipDirectory(zipURL: URL, destinationURL: URL){
        do {
            try Zip.unzipFile(zipURL, destination: destinationURL, overwrite: true, password: nil, progress: { (progress) -> () in
                print(progress)
            })
        }
        catch {
          print("Could not unzip files")
        }
    }
    
}
