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
    
    override func configureMapView(){
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.location.overrideLocationProvider(with: MapLocationProvider(name: "mapcaptureview"))
        mapView.location.options.puckType = .puck2D()
        mapView.location.addLocationConsumer(newConsumer: self)
        mapView.mapboxMap.style.uri = .satellite
        mapView.mapboxMap.onNext(.mapLoaded) { _ in
            self.mapLoaded = true
            self.mapView.location.addLocationConsumer(newConsumer: self)
        }
        captureButton.addTarget(self, action: #selector(save), for: .touchDown)
        mapView.addSubview(captureButton)
        captureButton.isEnabled = false
        captureButton.setAnchors()
            .bottom(mapView.bottomAnchor,inset: Statics.defaultInset)
            .centerX(mapView.centerXAnchor)
            .width(50)
            .height(50)
    }
    
    override func configureRightHeaderView(rightStackView: UIStackView){
        super.configureRightHeaderView(rightStackView: rightStackView)
        let closeButton = IconButton(icon: "xmark.circle")
        closeButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        rightStackView.addArrangedSubview(closeButton)
    }
    
    override func locationUpdate(newLocation: Location) {
        if location == nil{
            print("location at update")
            mapView.camera.ease(to: CameraOptions(center: newLocation.coordinate, zoom: startZoom), duration: 0.5)
            location = newLocation
        }
    }
    
    func didFinishLoading() {
        captureButton.isEnabled = true
    }
    
    @objc func save(){
        Indicator.shared.show()
        //todo
        /*
        mapView.takeScreenshot(){ result in
            switch result{
            case .success(let image):
                if self.data.saveMapSection(uiImage: image){
                    self.data.hasMapSection = true
                    if let delegate = self.delegate{
                        delegate.mapCaptured(data: self.data)
                    }
                }
                Indicator.shared.hide()
                self.dismiss(animated: true)
                return
            case .failure:
                print("error while taking screenshot")
                return
            }
        }

         */
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
}

