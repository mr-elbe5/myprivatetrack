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
    var appleAttribution : UIView? = nil
    var osmAttribution = UIView()
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
        appleAttribution = mkMapView.findAttributionLabel()
        addOsmAttribution(layoutGuide: guide)
        setAttributionForMapType()
    }
    
    func fillHeaderView(){
        let toggleStyleButton = IconButton(icon: "map", tintColor: .white)
        toggleStyleButton.addTarget(self, action: #selector(toggleMapStyle), for: .touchDown)
        leftStackView.addArrangedSubview(toggleStyleButton)
    }
    
    func addOsmAttribution(layoutGuide: UILayoutGuide){
        view.addSubview(osmAttribution)
        osmAttribution.setAnchors(trailing: layoutGuide.trailingAnchor, bottom: layoutGuide.bottomAnchor, insets: .zero)
        var label = UILabel()
        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .footnote)
        osmAttribution.addSubview(label)
        label.setAnchors(top: osmAttribution.topAnchor, leading: osmAttribution.leadingAnchor, bottom: osmAttribution.bottomAnchor)
        label.text = "© "
        let link = UIButton()
        link.setTitleColor(.systemBlue, for: .normal)
        link.titleLabel?.font = .preferredFont(forTextStyle: .footnote)
        osmAttribution.addSubview(link)
        link.setAnchors(top: osmAttribution.topAnchor, leading: label.trailingAnchor, bottom: osmAttribution.bottomAnchor)
        link.setTitle("OpenStreetMap", for: .normal)
        link.addTarget(self, action: #selector(openOSMUrl), for: .touchDown)
        label = UILabel()
        label.textColor = .darkGray
        label.font = .preferredFont(forTextStyle: .footnote)
        osmAttribution.addSubview(label)
        label.setAnchors(top: osmAttribution.topAnchor, leading: link.trailingAnchor, trailing: osmAttribution.trailingAnchor, bottom: osmAttribution.bottomAnchor, insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: defaultInset))
        label.text = " contributors"
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
    
    @objc func openOSMUrl() {
        UIApplication.shared.open(URL(string: "https://www.openstreetmap.org/copyright")!)
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
        setAttributionForMapType()
        mkMapView.setNeedsDisplay()
    }
    
    func setAttributionForMapType(){
        switch mapType{
        case .apple, .satellite:
            appleAttribution?.isHidden = false
            osmAttribution.isHidden = true
        case .osm:
            appleAttribution?.isHidden = true
            osmAttribution.isHidden = false
        }
    }
    
    func showError(_ reason: String){
        showAlert(title: "error".localize(), text: reason.localize())
    }
    
}

