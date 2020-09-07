//
//  AudioRecorder.swift
//
//  Created by Michael Rönnau on 09.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

public class AudioRecorderView : UIView, AVAudioRecorderDelegate{
    
    public var recordingSession: AVAudioSession? = nil
    public var audioRecorder: AVAudioRecorder? = nil
    public var isRecording: Bool = false
    public var currentTime: Double = 0.0
    
    public var url : URL? = nil
    
    public var player = AudioPlayerView()
    public var recordButton = CaptureButton()
    public var timeLabel = UILabel()
    public var progress = AudioProgressView()
    
    
    public func setupView() {
        backgroundColor = .black
        timeLabel.textAlignment = .center
        timeLabel.textColor = .white
        addSubview(timeLabel)
        progress.setupView()
        addSubview(progress)
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        addSubview(recordButton)
        self.recordButton.isEnabled = true
        player.setupView()
        player.backgroundColor = .systemBackground
        addSubview(player)
    }

    public func layoutView(){
        timeLabel.placeBelow(anchor: topAnchor)
        progress.placeBelow(view: timeLabel)
        progress.layoutView()
        recordButton.enableAnchors()
        recordButton.setTopAnchor(progress.bottomAnchor)
        recordButton.setCenterXAnchor(centerXAnchor)
        recordButton.setWidthAnchor(50)
        recordButton.setHeightAnchor(50)
        player.placeBelow(view: progress)
        player.layoutView()
        player.setBottomAnchor(bottomAnchor,padding: Statics.defaultInset)
        player.isHidden = true
        updateTime(time: 0.0)
    }
    
    public func enableRecording(){
        var success = true
        AVCaptureDevice.askAudioAuthorization(){ result in
            if result{
                self.recordingSession = AVAudioSession.sharedInstance()
                do {
                    try self.recordingSession!.setCategory(.playAndRecord, mode: .default)
                    try self.recordingSession!.setActive(true)
                    self.recordingSession!.requestRecordPermission() { allowed in
                        success = allowed
                    }
                } catch {
                    success = false
                }
            }
            else{
                success = false
            }
        }
        DispatchQueue.main.async {
            self.recordButton.isEnabled = success
        }
    }
    
    public func startRecording() {
        player.disablePlayer()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue,
            AVNumberOfChannelsKey: 1,
        ]
        if let url = url{
            do{
                audioRecorder = try AVAudioRecorder(url: url, settings: settings)
                audioRecorder!.isMeteringEnabled = true
                audioRecorder!.delegate = self
                audioRecorder!.record()
                isRecording = true
                self.recordButton.buttonState = .recording
                DispatchQueue.global(qos: .background).async {
                    repeat{
                        self.audioRecorder!.updateMeters()
                        DispatchQueue.main.async {
                            self.currentTime = self.audioRecorder!.currentTime
                            self.updateTime(time: self.currentTime)
                            self.updateProgress(decibels: self.audioRecorder!.averagePower(forChannel: 0))
                        }
                        // 1/10s
                        usleep(100000)
                    } while self.isRecording
                }
            }
            catch{
                recordButton.isEnabled = false
            }
        }
    }
    
    public func finishRecording(success: Bool) {
        isRecording = false
        audioRecorder?.stop()
        audioRecorder = nil
        if success {
            player.isHidden = false
            player.url = url
            player.enablePlayer()
        } else {
            player.disablePlayer()
            player.url = nil
        }
        recordButton.buttonState = .normal
    }
    
    public func updateTime(time: Double){
        timeLabel.text = String(format: "%.02f s", time)
    }
    
    public func updateProgress(decibels: Float){
        progress.setProgress((min(max(-60.0, decibels),0) + 60.0) / 60.0)
    }
    
    @objc public func toggleRecording() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: flag)
        }
    }
    
}

public class AudioProgressView : UIView{
    
    public var lowLabel = UIImageView(image: UIImage(systemName: "speaker"))
    public var progress = UIProgressView()
    public var loudLabel = UIImageView(image: UIImage(systemName: "speaker.3"))
    
    public func setupView() {
        backgroundColor = .clear
        lowLabel.tintColor = .white
        addSubview(lowLabel)
        progress.progressTintColor = .systemRed
        progress.progress = 0.0
        addSubview(progress)
        loudLabel.tintColor = .white
        addSubview(loudLabel)
        
    }
    
    public func layoutView(){
        lowLabel.placeAfter(anchor: leadingAnchor)
        loudLabel.placeBefore(anchor: trailingAnchor)
        progress.enableAnchors()
        progress.setLeadingAnchor(lowLabel.trailingAnchor,padding: defaultInset,priority: highPriority)
        progress.setTrailingAnchor(loudLabel.leadingAnchor, padding: defaultInset,priority: highPriority)
        progress.setCenterYAnchor(centerYAnchor,priority: highPriority)
    }
    
    func setProgress(_ value: Float){
        progress.setProgress(value, animated: true)
    }
    
}
