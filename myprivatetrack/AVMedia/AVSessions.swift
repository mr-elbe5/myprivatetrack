//
//  AVSessions.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 14.02.22.
//  Copyright © 2022 Michael Rönnau. All rights reserved.
//

import Foundation
import AVFoundation

class AVSessions{
    
    static var audioSession : AVAudioSession? = nil
    
    static func initSessions(){
        AVCaptureDevice.askAudioAuthorization(){ result in
            switch result{
            case .success(()):
                audioSession = AVAudioSession.sharedInstance()
                audioSession?.requestRecordPermission() { allowed in
                    do {
                        try audioSession?.setCategory(.playAndRecord, mode: .voiceChat, options: [])
                    } catch {
                        print("Failed to set audio session category.")
                    }
                }
            default:
                break
            }
        }
    }
    
    static var audioSessionAvailable: Bool{
        audioSession != nil
    }
    
    static func activateAudioSession() -> AVAudioSession?{
        try? audioSession?.setActive(true)
        return audioSession
    }
    
    static func deactivateAudioSession(){
        try? audioSession?.setActive(false)
    }
    
}
