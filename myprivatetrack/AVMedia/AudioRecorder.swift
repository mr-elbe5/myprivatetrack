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
    private var fileUrl: URL!
    
    let audioBufferQueue = DispatchQueue(label: "audio buffer queue")
    
    init(url: URL){
        super.init()
        fileUrl = url
        prepare()
    }
    
    func prepare() {
        AVCaptureDevice.askAudioAuthorization(){ result in
            let device: AVCaptureDevice = AVCaptureDevice.default(for: .audio)!
            var audioDeviceInput: AVCaptureDeviceInput?
            do {
                audioDeviceInput = try AVCaptureDeviceInput(device: device)
            } catch {
                audioDeviceInput = nil
                return
            }
            let audioDataOutput = AVCaptureAudioDataOutput()
            audioDataOutput.setSampleBufferDelegate(self, queue: self.audioBufferQueue)
            
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
            print(".")
            audioBufferQueue.async {
                if input.isReadyForMoreMediaData {
                    print("-")
                    input.append(sampleBuffer)
                }
            }
        }
    }
    
    private func prepareAssetWriter() -> Bool{
        do{
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let fileUrl = paths[0].appendingPathComponent("output.m4a")
            if FileController.fileExists(url: fileUrl){
                FileController.deleteFile(url: fileUrl)
            }
            self.assetWriter = try AVAssetWriter(outputURL: fileUrl, fileType: .m4a)
            print("asset writer created")
        }
        catch{
            print("could not create asset writer")
            assetWriter = nil
            return false
        }
        return true
    }
    
    func finishFile(){
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileUrl = paths[0].appendingPathComponent("output.m4a")
        if FileController.fileExists(url: fileUrl){
            FileController.copyFile(fromURL: fileUrl, toURL: self.fileUrl, replace: true)
        }
    }
    
    func start() -> Bool{
        print("start")
        if let session = session, prepareAssetWriter(), assetWriter.canAdd(audioInput) {
            sessionQueue.async {
                print("start running")
                session.startRunning()
                print("session is running: \(session.isRunning)")
            }
            print("adding audio input")
            assetWriter.add(audioInput)
            assetWriter.startWriting()
            return true
        }
        return false
    }
    
    func stop(writing finished: @escaping () -> Void) {
        if let session = session {
            if session.isRunning {
                session.stopRunning()
            }
        }
        if assetWriter.status == .writing {
            assetWriter.finishWriting(completionHandler: finished)
            finishFile()
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
