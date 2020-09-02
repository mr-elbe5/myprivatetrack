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
    public var progressContainer = UIView()
    public var lowLabel = UIImageView(image: UIImage(systemName: "speaker"))
    public var progress = UIProgressView()
    public var loudLabel = UIImageView(image: UIImage(systemName: "speaker.3"))
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        layoutView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupView() {
        backgroundColor = .black
        timeLabel.textAlignment = .center
        timeLabel.textColor = .white
        addSubview(timeLabel)
        addSubview(progressContainer)
        lowLabel.tintColor = .white
        progressContainer.addSubview(lowLabel)
        progress.progressTintColor = .systemRed
        progress.progress = 0.0
        progressContainer.addSubview(progress)
        loudLabel.tintColor = .white
        progressContainer.addSubview(loudLabel)
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        addSubview(recordButton)
        self.recordButton.isEnabled = true
        player.setupView()
        player.backgroundColor = .systemBackground
        addSubview(player)
    }

    public func layoutView(){
        timeLabel.placeBelow(anchor: topAnchor)
        progressContainer.placeBelow(view: timeLabel)
        lowLabel.placeAfter(anchor: progressContainer.leadingAnchor)
        loudLabel.placeBefore(anchor: progressContainer.trailingAnchor)
        progress.enableAnchors()
        progress.setLeadingAnchor(lowLabel.trailingAnchor, padding: defaultInset)
        progress.setTrailingAnchor(loudLabel.leadingAnchor, padding: defaultInset)
        progress.setCenterYAnchor(progressContainer.centerYAnchor)
        recordButton.enableAnchors()
        recordButton.setTopAnchor(progressContainer.bottomAnchor)
        recordButton.setCenterXAnchor(centerXAnchor)
        recordButton.setWidthAnchor(50)
        recordButton.setHeightAnchor(50)
        player.layoutView()
        player.placeBelow(view: recordButton)
        player.setBottomAnchor(bottomAnchor,padding: Statics.defaultInset)
        player.isHidden = true
        updateProgress(time: 0.0, decibels: 0.0)
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
                            self.updateProgress(time: self.currentTime,decibels: self.audioRecorder!.averagePower(forChannel: 0))
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
    
    public func updateProgress(time: Double, decibels: Float){
        timeLabel.text = String(format: "%.02f s", time)
        progress.setProgress((min(max(-60.0, decibels),0) + 60.0) / 60.0, animated: true)
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
