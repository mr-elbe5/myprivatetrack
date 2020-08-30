//
//  ImageCaptureViewController.swift
//
//  Created by Michael Rönnau on 23.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos

protocol ImageCaptureDelegate{
    func imageCaptured(data: ImageData)
}

class ImageCaptureViewController: CameraViewController, AVCapturePhotoCaptureDelegate {
    static var qualityItems : Array<UIImage> = [UIImage(systemName: "hare")!,UIImage(systemName: "gauge")!,UIImage(systemName: "tortoise")!]
    
    var data : ImageData!
    
    var delegate: ImageCaptureDelegate? = nil
    
    var cancelButton = IconButton(icon: "chevron.left", tintColor: .white)
    var captureButton = CaptureButton()
    var cameraButton = IconButton(icon: "camera.rotate", tintColor: .white)
    var photoQualityControl = UISegmentedControl(items: qualityItems)
    
    private let photoOutput = AVCapturePhotoOutput()
    private var photoQuality: AVCapturePhotoOutput.QualityPrioritization = .balanced
    
    override func addButtons(){
        buttonView.backgroundColor = .black
        cancelButton.setTitle("back".localize(), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        buttonView.addSubview(cancelButton)
        cancelButton.placeAfter(anchor: buttonView.leadingAnchor, padding: Statics.flatInsets)
        photoQualityControl.backgroundColor = .clear
        photoQualityControl.setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
        photoQualityControl.selectedSegmentIndex = 1
        photoQualityControl.selectedSegmentTintColor = UIColor.systemGray2
        photoQualityControl.addTarget(self, action: #selector(togglePhotoQuality), for: .valueChanged)
        buttonView.addSubview(photoQualityControl)
        photoQualityControl.placeXCentered(padding: Statics.flatInsets)
        cameraButton.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        cameraButton.addTarget(self, action: #selector(changeCamera), for: .touchDown)
        buttonView.addSubview(cameraButton)
        cameraButton.placeBefore(anchor: buttonView.trailingAnchor, padding: Statics.flatInsets)
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchDown)
        bodyView.addSubview(captureButton)
        captureButton.enableAnchors()
        captureButton.setBottomAnchor(buttonView.topAnchor,padding: Statics.defaultInset)
        captureButton.setCenterXAnchor(bodyView.centerXAnchor)
        captureButton.setWidthAnchor(50)
        captureButton.setHeightAnchor(50)
    }
    
    override func enableButtons(flag: Bool){
        cancelButton.isEnabled = flag
        enableCameraButtons(flag: flag)
    }
    
    override func enableCameraButtons(flag: Bool){
        captureButton.isEnabled = flag
        cameraButton.isEnabled = flag
        photoQualityControl.isEnabled = flag
    }
    
    func configurePhoto(){
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
            
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
            photoOutput.isDepthDataDeliveryEnabled = photoOutput.isDepthDataDeliverySupported
            photoOutput.isPortraitEffectsMatteDeliveryEnabled = photoOutput.isPortraitEffectsMatteDeliverySupported
            photoOutput.enabledSemanticSegmentationMatteTypes = photoOutput.availableSemanticSegmentationMatteTypes
            photoOutput.maxPhotoQualityPrioritization = .quality
            photoQuality = .balanced
            
        } else {
            print("Could not add photo output to the session")
            isInputAvailable = false
            session.commitConfiguration()
            return
        }
    }
    
    override func configureSession(){
        isInputAvailable = true
        session.beginConfiguration()
        session.sessionPreset = .photo
        configureVideo()
        if !isInputAvailable{
            return
        }
        configurePhoto()
        if !isInputAvailable {
            return
        }
        
        photoQuality = .balanced
        session.commitConfiguration()
    }
    
    override func replaceVideoDevice(newVideoDevice videoDevice: AVCaptureDevice){
        let currentVideoDevice = self.videoDeviceInput.device
        
        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            self.session.beginConfiguration()
            
            self.session.removeInput(self.videoDeviceInput)
            
            if self.session.canAddInput(videoDeviceInput) {
                NotificationCenter.default.removeObserver(self, name: .AVCaptureDeviceSubjectAreaDidChange, object: currentVideoDevice)
                NotificationCenter.default.addObserver(self, selector: #selector(self.subjectAreaDidChange), name: .AVCaptureDeviceSubjectAreaDidChange, object: videoDeviceInput.device)
                
                self.session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                self.session.addInput(self.videoDeviceInput)
            }
            
            self.photoOutput.maxPhotoQualityPrioritization = .quality
            
            self.session.commitConfiguration()
        } catch {
            print("Error occurred while creating video device input: \(error)")
        }
    }
    
    @objc func capturePhoto() {
        let videoPreviewLayerOrientation = preview.videoPreviewLayer.connection?.videoOrientation
        
        sessionQueue.async {
            if let photoOutputConnection = self.photoOutput.connection(with: .video) {
                photoOutputConnection.videoOrientation = videoPreviewLayerOrientation!
            }
            var photoSettings = AVCapturePhotoSettings()
            if  self.photoOutput.availablePhotoCodecTypes.contains(.jpeg) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            }
            if self.videoDeviceInput.device.isFlashAvailable {
                photoSettings.flashMode = .auto
            }
            photoSettings.isHighResolutionPhotoEnabled = true
            if !photoSettings.__availablePreviewPhotoPixelFormatTypes.isEmpty {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
            }
            photoSettings.isDepthDataDeliveryEnabled = false
            photoSettings.photoQualityPrioritization = self.photoQuality
            // shutter animation
            DispatchQueue.main.async {
                self.preview.videoPreviewLayer.opacity = 0
                UIView.animate(withDuration: 0.25) {
                    self.preview.videoPreviewLayer.opacity = 1
                }
            }
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
        } else {
            if let photoData = photo.fileDataRepresentation(){
                let data = ImageData()
                data.saveImage(uiImage: UIImage(data: photoData))
                delegate?.imageCaptured(data: data)
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func togglePhotoQuality() {
        let selectedQuality = photoQualityControl.selectedSegmentIndex
        sessionQueue.async {
            switch selectedQuality {
            case 0 :
                self.photoQuality = .speed
            case 1 :
                self.photoQuality = .balanced
            case 2 :
                self.photoQuality = .quality
            default:
                break
            }
        }
    }
    
    override func addObservers(){
        let keyValueObservation = session.observe(\.isRunning, options: .new) { _, change in
            guard let isSessionRunning = change.newValue else { return }
            DispatchQueue.main.async {
                // Only enable the ability to change camera if the device has more than one camera.
                self.cameraButton.isEnabled = isSessionRunning && self.videoDeviceDiscoverySession.uniqueDevicePositionsCount > 1
                self.captureButton.isEnabled = isSessionRunning
                self.photoQualityControl.isEnabled = isSessionRunning
            }
        }
        keyValueObservations.append(keyValueObservation)
        super.addObservers()
    }
    
}
