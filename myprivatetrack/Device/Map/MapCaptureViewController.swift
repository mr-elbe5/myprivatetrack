//
//  LocationCaptureViewController.swift
//
//  Created by Michael Rönnau on 23.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapboxMaps
import SwiftyIOSViewExtensions

protocol MapCaptureDelegate{
    func mapCaptured(data: EntryData)
}

class MapCaptureViewController: MapViewController{
    
    var data : EntryData!
    
    var delegate: MapCaptureDelegate? = nil
    
    
    var buttonView = UIView()
    var captureButton = CaptureButton()
    
    var snapshotter : Snapshotter? = nil
    
    override func loadView() {
        super.loadView()
        let guide = view.safeAreaLayoutGuide
        view.addSubview(headerView)
        headerView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(guide.topAnchor,inset: .zero)
            .trailing(guide.trailingAnchor,inset: .zero)
        let leftStackView = UIStackView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(leftStackView)
        headerView.addSubview(rightStackView)
        leftStackView.setupHorizontal(spacing: defaultInset)
        leftStackView.placeAfter(anchor: headerView.leadingAnchor, insets: defaultInsets)
        rightStackView.setupHorizontal(spacing: defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, insets: defaultInsets)
        let toggleStyleButton = IconButton(icon: "map")
        toggleStyleButton.addTarget(self, action: #selector(toggleMapStyle), for: .touchDown)
        leftStackView.addArrangedSubview(toggleStyleButton)
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        let closeButton = IconButton(icon: "xmark.circle")
        closeButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        rightStackView.addArrangedSubview(closeButton)
        mapView = MapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let locationProvider = MapLocationProvider()
        LocationService.shared.captureDelegate = locationProvider
        mapView.location.overrideLocationProvider(with: locationProvider)
        mapView.location.options.puckType = .puck2D()
        mapView.location.addLocationConsumer(newConsumer: self)
        mapView.mapboxMap.style.uri = .satellite
        mapView.mapboxMap.onNext(.mapLoaded) { _ in
            self.mapLoaded = true
            self.mapView.location.addLocationConsumer(newConsumer: self)
        }
        view.addSubview(mapView)
        mapView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(headerView.bottomAnchor, inset: 1)
            .trailing(guide.trailingAnchor,inset: .zero)
            .bottom(guide.bottomAnchor)
        mapView.addSubview(buttonView)
        buttonView.setAnchors()
            .centerX(mapView.centerXAnchor)
            .bottom(mapView.bottomAnchor, inset: Statics.defaultInset)
            .height(50)
            .width(50)
        captureButton.addTarget(self, action: #selector(save), for: .touchDown)
        buttonView.addSubview(captureButton)
        captureButton.isEnabled = true
        captureButton.setAnchors()
            .centerX(buttonView.centerXAnchor)
            .centerY(buttonView.centerYAnchor)
            .height(50)
            .width(50)
    }
    
    override func locationUpdate(newLocation: Location) {
        if location == nil{
            print("location at update")
            mapView.camera.ease(to: CameraOptions(center: newLocation.coordinate, zoom: startZoom), duration: 0.5)
            location = newLocation
        }
    }
    
    @objc func save(){
        print("save")
        Indicator.shared.show()
        let options = MapSnapshotOptions(size: mapView.bounds.size, pixelRatio: 1)
        snapshotter = Snapshotter(options: options)
        print(snapshotter!.snapshotSize)
        let cameraOptions = CameraOptions(center: mapView.cameraState.center, padding: nil, anchor: nil, zoom: mapView.cameraState.zoom, bearing: mapView.cameraState.bearing, pitch: mapView.cameraState.pitch)
        snapshotter!.setCamera(to: cameraOptions)
        print(snapshotter!.cameraState)
        self.snapshotter!.start(overlayHandler: nil, completion: self.snapshotResult)
    }
    
    func snapshotResult(result: Result<UIImage, Snapshotter.SnapshotError>){
        print("callback")
        switch result{
        case .success(let image):
            print("success")
            if self.data.saveMapSection(uiImage: image){
                self.data.hasMapSection = true
                if let delegate = self.delegate{
                    delegate.mapCaptured(data: self.data)
                }
            }
        case .failure(let error):
            print("error while taking screenshot: \(error)")
        }
        Indicator.shared.hide()
        self.snapshotter = nil
        self.dismiss(animated: true)
    }

    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
}

