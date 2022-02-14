//
//  AudioRecorder.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 14.02.22.
//  Copyright © 2022 Michael Rönnau. All rights reserved.
//

import Foundation
import AVFoundation

class AudioRecorder: NSObject, AVCaptureAudioDataOutputSampleBufferDelegate{
    
    private var assetWriter: AVAssetWriter!
    private var videoInput: AVAssetWriterInput!
    private var audioInput: AVAssetWriterInput!
    private var session: AVCaptureSession!
    private let sessionQueue = DispatchQueue(label: "audio session queue")
    private var isSessionStarted = false
    
    private var audioSettings: [String: Any]? = nil
    
    let audioBufferQueue = DispatchQueue(label: "audio buffer queue")

    override init(){
        super.init()
        AVCaptureDevice.askAudioAuthorization(){ result in
            self.sessionQueue.async {
                if self.prepareFileWriter(){
                    self.prepareAudioDevice(with: self.sessionQueue)
                }
            }
        }
    }
    
    func prepareFileWriter() -> Bool{
        do{
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("output.m4a")
            try FileManager.default.removeItem(at: fileUrl)
            self.assetWriter = try AVAssetWriter(outputURL: fileUrl, fileType: .m4a)
        }
        catch{
            print("could not create asset writer")
            return false
        }
        return true
    }
    
    func prepareAudioDevice(with queue: DispatchQueue) {
        let device: AVCaptureDevice = AVCaptureDevice.default(for: .audio)!
        var audioDeviceInput: AVCaptureDeviceInput?
        do {
            audioDeviceInput = try AVCaptureDeviceInput(device: device)
        } catch {
            audioDeviceInput = nil
        }
        
        let audioDataOutput = AVCaptureAudioDataOutput()
        audioDataOutput.setSampleBufferDelegate(self, queue: queue)
        
        session = AVCaptureSession()
        session.sessionPreset = .medium
        session.usesApplicationAudioSession = true
        session.automaticallyConfiguresApplicationAudioSession = false
        
        if session.canAddInput(audioDeviceInput!) {
            session.addInput(audioDeviceInput!)
        }
        if session.canAddOutput(audioDataOutput) {
            session.addOutput(audioDataOutput)
        }
        audioSettings = audioDataOutput.recommendedAudioSettingsForAssetWriter(writingTo: .m4v)
        audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: audioSettings)
        audioInput.expectsMediaDataInRealTime = true
        audioBufferQueue.async {
            self.session.startRunning()
        }
        if assetWriter.canAdd(audioInput) {
            assetWriter.add(audioInput)
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let input = audioInput {
            audioBufferQueue.async {
                if input.isReadyForMoreMediaData {
                    input.append(sampleBuffer)
                }
            }
        }
    }
    
    func end(writing finished: @escaping () -> Void) {
        if let session = session {
            if session.isRunning {
                session.stopRunning()
            }
        }
        if assetWriter.status == .writing {
            assetWriter.finishWriting(completionHandler: finished)
        }
    }
    
    func cancel() {
        if let session = session {
            if session.isRunning {
                session.stopRunning()
            }
        }
        assetWriter.cancelWriting()
    }
    
}
