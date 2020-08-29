//
//  Authorization.swift
//  E5Data
//
//  Created by Michael Rönnau on 25.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import AVFoundation
import Photos

public class AuthorizationError : Error{
    
}

public class Authorization{
    
    public static func askPhotoLibraryAuthorization(callback: @escaping (_ result: Bool) -> Void){
        switch PHPhotoLibrary.authorizationStatus(){
        case .authorized:
            callback(true)
            break
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(){ granted in
                if granted == .authorized{
                    callback(true)
                }
                else{
                    callback(false)
                }
            }
            break
        default:
            callback(false)
            break
        }
    }
    
    public static func isPhotoLibraryAuthorized() -> Bool{
        return PHPhotoLibrary.authorizationStatus() == .authorized
    }
    
    public static func askCameraAuthorization(callback: @escaping (_ result: Bool) -> Void){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            callback(true)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ granted in
                if granted{
                    callback(true)
                }
                else{
                    callback(false)
                }
            }
            break
        default:
            callback(false)
            break
        }
    }
    
    public static func isCameraAuthorized() -> Bool{
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    public static func askAudioAuthorization(callback: @escaping (_ result: Bool) -> Void){
        switch AVCaptureDevice.authorizationStatus(for: .audio){
        case .authorized:
            callback(true)
            break
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio){ granted in
                if granted{
                    callback(true)
                }
                else{
                    callback(false)
                }
            }
            break
        default:
            callback(false)
            break
        }
    }
    
    public static func isAudioAuthorized() -> Bool{
        return AVCaptureDevice.authorizationStatus(for: .audio) == .authorized
    }
    
    public static func askVideoAuthorization(callback: @escaping (_ result: Bool) -> Void){
        askCameraAuthorization(){ result in
            if !result{
                callback(false)
                return
            }
            askAudioAuthorization(){result in
                callback(result)
            }
        }
    }
    
    public static func askLocationAuthorization(callback: @escaping (_ result: Bool) -> Void){
        if CLLocationManager.authorizationStatus() == .notDetermined{
            LocationService.shared.requestWhenInUseAuthorization()
        }
        callback(true)
    }
    
    public static func isLocationAuthorized() -> Bool{
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    public static func askAllAuthorizations(callback: @escaping (_ result: Bool) -> Void){
        askPhotoLibraryAuthorization(){ result in
            if !result{
                callback(false)
                return
            }
            askCameraAuthorization(){ result in
                if !result{
                    callback(false)
                    return
                }
                askAudioAuthorization(){ result in
                    if !result{
                        callback(false)
                        return
                    }
                    askLocationAuthorization(){ result in
                        callback(result)
                    }
                }
            }
        }
        
        
    }
    
}
