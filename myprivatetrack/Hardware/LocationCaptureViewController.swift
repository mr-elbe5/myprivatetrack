//
//  LocationCaptureViewController.swift
//
//  Created by Michael Rönnau on 23.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

protocol LocationCaptureDelegate{
    func locationCaptured(data: MapData)
}

class LocationCaptureViewController: UIViewController, CLLocationManagerDelegate, MapViewDelegate {
    
    var data : MapData!
    var coordinate : CLLocationCoordinate2D!
    
    var delegate: LocationCaptureDelegate? = nil
    
    var mapView = MapView()
    var bodyView = UIView()
    var buttonView = UIView()
    var cancelButton = IconButton(icon: "chevron.left", tintColor: .white)
    var mapTypeButton = IconButton(icon: "map", tintColor: .white)
    var captureButton = CaptureButton()
    
    override func loadView() {
        super.loadView()
        self.modalPresentationStyle = .fullScreen
        bodyView.backgroundColor = .black
        view.addSubview(bodyView)
        bodyView.fillSafeAreaOf(view: view, padding: .zero)
        bodyView.addSubview(mapView)
        mapView.setupView()
        mapView.setLocation(coordinate: coordinate)
        mapView.placeBelow(anchor: bodyView.topAnchor, padding: .zero)
        mapView.delegate = self
        buttonView.backgroundColor = .black
        bodyView.addSubview(buttonView)
        buttonView.placeBelow(view: mapView)
        addButtons()
        buttonView.connectBottom(view: bodyView)
    }
    
    func addButtons(){
        
        cancelButton.setTitle("back".localize(), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        buttonView.addSubview(cancelButton)
        cancelButton.placeAfter(anchor: buttonView.leadingAnchor, padding: Statics.defaultInsets)
        
        captureButton.addTarget(self, action: #selector(save), for: .touchDown)
        mapView.addSubview(captureButton)
        captureButton.isEnabled = false
        captureButton.enableAnchors()
        captureButton.setBottomAnchor(buttonView.topAnchor,padding: Statics.defaultInset)
        captureButton.setCenterXAnchor(mapView.centerXAnchor)
        captureButton.setWidthAnchor(50)
        captureButton.setHeightAnchor(50)
        
        mapTypeButton.addTarget(self, action: #selector(toggleMapType), for: .touchDown)
        buttonView.addSubview(mapTypeButton)
        mapTypeButton.isEnabled = false
        mapTypeButton.placeXCentered()
        
    }
    
    func didFinishLoading() {
        captureButton.isEnabled = true
        mapTypeButton.isEnabled = true
    }
    
    @objc func toggleMapType(){
        mapView.toggleMapType()
        if mapView.mapType == .satellite {
            mapTypeButton.setImage(UIImage(systemName: "map"), for: .normal)
        }else{
            mapTypeButton.setImage(UIImage(systemName: "map.fill"), for: .normal)
        }
    }
    
    @objc func save(){
        let indicator = UIActivityIndicatorView(frame: CGRect(x: self.mapView.center.x - 30, y: self.mapView.center.y - 30, width: 60, height: 60))
        view.addSubview(indicator)
        indicator.startAnimating()
        mapView.takeScreenshot(){ screenshot in
            if let screenshot = screenshot{
                self.data.saveImage(uiImage: screenshot)
                if let delegate = self.delegate{
                    delegate.locationCaptured(data: self.data)
                }
                indicator.stopAnimating()
                self.dismiss(animated: true)
            }
            else{
                print("error while taking screenshot")
            }
        }
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
}

