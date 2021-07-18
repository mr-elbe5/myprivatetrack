//
//  MapViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 18.07.21.
//  Copyright © 2021 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapboxMaps
import SwiftyIOSViewExtensions

class MapViewController: UIViewController, LocationConsumer {
    
    var headerView = UIView()
    var mapView : MapView!
    var mapLoaded = false
    var location: Location? = nil
    var startZoom : CGFloat{
        get{
            Settings.shared.mapStartZoom
        }
    }
    
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
        rightStackView.leading(leftStackView.trailingAnchor)
        configureLeftHeaderView(leftStackView: leftStackView)
        configureRightHeaderView(rightStackView: rightStackView)
        mapView = MapView(frame: view.bounds)
        configureMapView()
        view.addSubview(mapView)
        mapView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(headerView.bottomAnchor, inset: 1)
            .trailing(guide.trailingAnchor,inset: .zero)
            .bottom(guide.bottomAnchor, inset: .zero)
    }
    
    func configureLeftHeaderView(leftStackView: UIStackView){
        let toggleStyleButton = IconButton(icon: "map")
        toggleStyleButton.addTarget(self, action: #selector(toggleMapStyle), for: .touchDown)
        leftStackView.addArrangedSubview(toggleStyleButton)
    }
    
    func configureRightHeaderView(rightStackView: UIStackView){
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
    }
    
    func configureMapView(){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let coordinate = LocationService.shared.lastLocation?.coordinate{
            mapView.camera.ease(
                to: CameraOptions(center: coordinate, zoom: startZoom),
                duration: 0.0)
            location = Location(with: LocationService.shared.lastLocation!)
        }
    }
    
    func locationUpdate(newLocation: Location) {
        if location == nil{
            mapView.camera.ease(to: CameraOptions(center: newLocation.coordinate, zoom: startZoom), duration: 0.5)
            location = newLocation
        }
    }
    
    @objc func toggleMapStyle() {
        if mapView.mapboxMap.style.uri == .satellite{
            mapView.mapboxMap.style.uri = .streets
        }
        else{
            mapView.mapboxMap.style.uri = .satellite
        }
    }
    
    @objc func showInfo(){
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
}

