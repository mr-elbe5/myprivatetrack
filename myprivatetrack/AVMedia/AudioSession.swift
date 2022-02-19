/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import AVFoundation

class AudioSession{
    
    static var isEnabled = false
    
    static func enableRecording(callback: @escaping (Result<Void, Error>) -> Void){
        if isEnabled{
            callback(.success(()))
        }
        else{
            AVCaptureDevice.askAudioAuthorization(){ result in
                switch result{
                case .success(()):
                    do {
                        let session = AVAudioSession.sharedInstance()
                        try session.setCategory(.playAndRecord, mode: .default)
                        try session.overrideOutputAudioPort(.speaker)
                        try session.setActive(true)
                        session.requestRecordPermission() { allowed in
                            isEnabled = true
                            callback(.success(()))
                        }
                    } catch {
                        callback(.failure(NSError()))
                    }
                    return
                case .failure:
                    callback(.failure(NSError()))
                    return
                }
            }
        }
    }
    
}
