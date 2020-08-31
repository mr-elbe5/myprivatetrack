//
//  AVCaptureDevice.swift
//
//  Created by Michael Rönnau on 27.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import Photos

extension AVCaptureDevice {
    
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
    
}


extension AVCaptureDevice.DiscoverySession {
    
    public var uniqueDevicePositionsCount: Int {
        
        var uniqueDevicePositions = [AVCaptureDevice.Position]()
        
        for device in devices where !uniqueDevicePositions.contains(device.position) {
            uniqueDevicePositions.append(device.position)
        }
        
        return uniqueDevicePositions.count
    }
    
}
