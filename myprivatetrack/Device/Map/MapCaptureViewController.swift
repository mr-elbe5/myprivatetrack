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

protocol MapCaptureDelegate{
    func mapCaptured(data: EntryData)
}

class MapCaptureViewController: UIViewController, LocationServiceDelegate, MapViewDelegate {
    
    var data : EntryData!
    
    var delegate: MapCaptureDelegate? = nil
    
    var mapView = MapView()
    var bodyView = UIView()
    var buttonView = UIView()
    var mapTypeButton = IconButton(icon: "map", tintColor: .white)
    var captureButton = CaptureButton()
    
    override func loadView() {
        super.loadView()
        LocationService.shared.checkRunning()
        self.modalPresentationStyle = .fullScreen
        bodyView.backgroundColor = .black
        view.addSubview(bodyView)
        bodyView.fillSafeAreaOf(view: view, insets: .zero)
        let closeButton = IconButton(icon: "xmark.circle", tintColor: .white)
        bodyView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        closeButton.setAnchors(top: bodyView.topAnchor, trailing: bodyView.trailingAnchor, insets: defaultInsets)
        bodyView.addSubview(mapView)
        mapView.setupView()
        if let loc = LocationService.shared.getLocation(){
            mapView.setLocation(location: loc)
        }
        mapView.setAnchors(top: closeButton.bottomAnchor, leading: bodyView.leadingAnchor, trailing: bodyView.trailingAnchor, insets: defaultInsets)
        mapView.delegate = self
        buttonView.backgroundColor = .black
        bodyView.addSubview(buttonView)
        buttonView.setAnchors(top: mapView.bottomAnchor, leading: bodyView.leadingAnchor, trailing: bodyView.trailingAnchor, bottom: bodyView.bottomAnchor, insets: defaultInsets)
        addButtons()
    }
    
    func addButtons(){
        
        captureButton.addTarget(self, action: #selector(save), for: .touchDown)
        mapView.addSubview(captureButton)
        captureButton.isEnabled = false
        captureButton.setAnchors(bottom: buttonView.topAnchor, insets: defaultInsets)
            .centerX(mapView.centerXAnchor)
            .width(50)
            .height(50)
        
        mapTypeButton.addTarget(self, action: #selector(toggleMapType), for: .touchDown)
        buttonView.addSubview(mapTypeButton)
        mapTypeButton.isEnabled = false
        mapTypeButton.setAnchors(top: buttonView.topAnchor, bottom: buttonView.bottomAnchor, insets: defaultInsets)
            .centerX(buttonView.centerXAnchor)
        
    }
    
    func didFinishLoading() {
        captureButton.isEnabled = true
        mapTypeButton.isEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LocationService.shared.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LocationService.shared.delegate = nil
    }
    
    func locationDidChange(location: Location){
        mapView.setLocation(location: location)
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
        Indicator.shared.show()
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
    }
    
    @objc func cancel(){
        self.dismiss(animated: true)
    }
    
}

