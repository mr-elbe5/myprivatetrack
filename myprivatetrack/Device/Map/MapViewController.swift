//
//  BaseMapViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 28.01.22.
//  Copyright © 2022 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var headerView = UIView()
    var leftStackView = UIStackView()
    var rightStackView = UIStackView()
    var mkMapView = MKMapView()
    var mapLoaded = false
    
    var mapType : MapType = .apple
    var overlay : MKTileOverlay? = nil
    
    override func loadView() {
        super.loadView()
        LocationService.shared.checkRunning()
        let guide = view.safeAreaLayoutGuide
        view.addSubview(headerView)
        headerView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: .zero)
        headerView.backgroundColor = UIColor.black
        headerView.addSubview(leftStackView)
        headerView.addSubview(rightStackView)
        leftStackView.setupHorizontal(spacing: defaultInset)
        leftStackView.setAnchors(top: headerView.topAnchor, leading: headerView.leadingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        rightStackView.setupHorizontal(spacing: defaultInset)
        rightStackView.setAnchors(top: headerView.topAnchor, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
        fillHeaderView()
        mkMapView.delegate = self
        mkMapView.mapType = .standard
        mkMapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mkMapView)
        mkMapView.setAnchors(top: headerView.bottomAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: .zero)
    }
    
    func fillHeaderView(){
        let toggleStyleButton = IconButton(icon: "map", tintColor: .white)
        toggleStyleButton.addTarget(self, action: #selector(toggleMapStyle), for: .touchDown)
        leftStackView.addArrangedSubview(toggleStyleButton)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapLoaded = true
        assertMapPins()
    }
    
    func assertMapPins(){
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = self.overlay{
            return MKTileOverlayRenderer(tileOverlay: overlay)
        }
        return MKTileOverlayRenderer()
    }
    
    @objc func toggleMapStyle() {
        switch mapType{
        case .apple:
            mapType = .osm
        case .osm:
            mapType = .satellite
        case .satellite:
            mapType = .apple
        }
        setupMapStyle()
    }
    
    func setupMapStyle(){
        if let overlay = overlay {
            mkMapView.removeOverlay(overlay)
            self.overlay = nil
        }
        switch mapType{
        case .apple:
            mkMapView.mapType = .standard
        case .osm:
            mkMapView.mapType = .standard
            overlay = MKTileOverlay(urlTemplate: Settings.osmUrl)
            overlay!.canReplaceMapContent = true
            mkMapView.addOverlay(overlay!)
        case .satellite:
            mkMapView.mapType = .satellite
        }
        mkMapView.setNeedsDisplay()
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
}

