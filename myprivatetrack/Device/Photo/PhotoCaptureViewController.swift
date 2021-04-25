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
import SwiftyIOSViewExtensions

protocol PhotoCaptureDelegate{
    func photoCaptured(data: PhotoData)
}

class PhotoCaptureViewController: CameraViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static var qualityItems : Array<String> = ["speed".localize(),"balanced".localize(),"quality".localize()]
    
    var data : PhotoData!
    
    var delegate: PhotoCaptureDelegate? = nil
    
    var captureButton = CaptureButton()
    var photoQualityControl = UISegmentedControl(items: qualityItems)
    var libraryButton = IconButton(icon: "photo", tintColor: .white)
    var flashButton = IconButton(icon: "bolt.badge.a", tintColor: .white)
    var cameraButton = IconButton(icon: "camera.rotate", tintColor: .white)
    
    private let photoOutput = AVCapturePhotoOutput()
    private var photoQuality: AVCapturePhotoOutput.QualityPrioritization = .balanced
    private var flashMode : AVCaptureDevice.FlashMode = Settings.shared.flashMode
    
    override func addButtons(){
        buttonView.backgroundColor = .black
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchDown)
        bodyView.addSubview(captureButton)
        captureButton.setAnchors()
            .bottom(buttonView.topAnchor,inset: Statics.defaultInset)
            .centerX(bodyView.centerXAnchor)
            .width(50)
            .height(50)
        photoQualityControl.backgroundColor = .clear
        photoQualityControl.setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)], for: .normal)
        photoQualityControl.selectedSegmentIndex = 1
        photoQualityControl.selectedSegmentTintColor = UIColor.systemGray2
        photoQualityControl.addTarget(self, action: #selector(togglePhotoQuality), for: .valueChanged)
        buttonView.addSubview(photoQualityControl)
        photoQualityControl.placeBelow(anchor: buttonView.topAnchor)
        let bottomView = UIView()
        bottomView.backgroundColor = .clear
        buttonView.addSubview(bottomView)
        bottomView.placeBelow(view: photoQualityControl)
        bottomView.connectBottom(view: buttonView)
        libraryButton.addTarget(self, action: #selector(selectImage), for: .touchDown)
        bottomView.addSubview(libraryButton)
        libraryButton.placeAfter(anchor: bottomView.leadingAnchor)
        cameraButton.setImage(UIImage(systemName: "camera.rotate"), for: .normal)
        cameraButton.addTarget(self, action: #selector(changeCamera), for: .touchDown)
        bottomView.addSubview(cameraButton)
        cameraButton.placeBefore(anchor: bottomView.trailingAnchor)
        flashButton.setImage(UIImage(systemName: "bolt.badge.a"), for: .normal)
        flashButton.addTarget(self, action: #selector(toggleFlash), for: .touchDown)
        bottomView.addSubview(flashButton)
        flashButton.placeBefore(anchor: cameraButton.leadingAnchor,insets: UIEdgeInsets(top: defaultInset, left: defaultInset, bottom: defaultInset, right: 2*defaultInset))
    }
    
    override func enableButtons(flag: Bool){
        libraryButton.isEnabled = flag
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
            photoOutput.isLivePhotoCaptureEnabled = false
            photoOutput.isDepthDataDeliveryEnabled = false
            photoOutput.isPortraitEffectsMatteDeliveryEnabled = false
            photoOutput.enabledSemanticSegmentationMatteTypes = []
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
    
    @objc func toggleFlash() {
        switch flashMode{
        case .auto:
            flashMode = .on
            self.flashButton.setImage(UIImage(systemName: "bolt"), for: .normal)
            break
        case .on:
            flashMode = .off
            self.flashButton.setImage(UIImage(systemName: "bolt.slash"), for: .normal)
            break
        default:
            flashMode = .auto
            self.flashButton.setImage(UIImage(systemName: "bolt.badge.a"), for: .normal)
            break
        }
        Settings.shared.flashMode = flashMode
        Settings.shared.save()
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
                photoSettings.flashMode = self.flashMode
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
            if let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData){
                let data = PhotoData()
                data.saveImage(uiImage: image)
                delegate?.photoCaptured(data: data)
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
    
    @objc func selectImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        pickerController.modalPresentationStyle = .fullScreen
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let imageURL = info[.imageURL] as? URL else {return}
        if FileController.copyFile(fromURL: imageURL, toURL: data.fileURL){
            delegate?.photoCaptured(data: data)
            picker.dismiss(animated: false){
                self.dismiss(animated: true)
            }
        }
        else{
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}
