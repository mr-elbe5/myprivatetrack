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
    private var audioSettings: [String: Any]? = nil
    
    let audioBufferQueue = DispatchQueue(label: "audio buffer queue")
    
    func prepare() {
        AVCaptureDevice.askAudioAuthorization(){ result in
            let device: AVCaptureDevice = AVCaptureDevice.default(for: .audio)!
            var audioDeviceInput: AVCaptureDeviceInput?
            do {
                audioDeviceInput = try AVCaptureDeviceInput(device: device)
            } catch {
                audioDeviceInput = nil
            }
            
            let audioDataOutput = AVCaptureAudioDataOutput()
            audioDataOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
            
            self.session = AVCaptureSession()
            self.session.sessionPreset = .medium
            self.session.usesApplicationAudioSession = true
            self.session.automaticallyConfiguresApplicationAudioSession = false
            
            if self.session.canAddInput(audioDeviceInput!) {
                self.session.addInput(audioDeviceInput!)
            }
            if self.session.canAddOutput(audioDataOutput) {
                self.session.addOutput(audioDataOutput)
            }
            self.audioSettings = audioDataOutput.recommendedAudioSettingsForAssetWriter(writingTo: .m4v)
            self.audioInput = AVAssetWriterInput(mediaType: .audio, outputSettings: self.audioSettings)
            self.audioInput.expectsMediaDataInRealTime = true
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
    
    private func prepareFileWriter() -> Bool{
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
    
    func start() -> Bool{
        if let session = session, prepareFileWriter(), assetWriter.canAdd(audioInput) {
            audioBufferQueue.async {
                session.startRunning()
            }
            assetWriter.add(audioInput)
            return true
        }
        return false
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
