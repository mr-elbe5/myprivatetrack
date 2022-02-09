/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, LocationServiceDelegate {
    
    var headerView = UIView()
    var leftStackView = UIStackView()
    var rightStackView = UIStackView()
    var mkMapView = MKMapView()
    var mapLoaded = false
    
    var mapType : MapType = .apple
    var appleAttribution : UIView? = nil
    var osmAttribution = UIView()
    var tileOverlay : MKTileOverlay? = nil
    var location: Location? = nil
    var radius : CLLocationDistance = 10000
    
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
        mkMapView.showsUserLocation = true
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
        let infoButton = IconButton(icon: "info.circle", tintColor: .white)
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
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
    
    func locationDidChange(location: Location){
        if self.location == nil{
            self.location = location
            mkMapView.centerToLocation(location, regionRadius: self.radius)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if LocationService.shared.authorized{
            if location == nil{
                location = LocationService.shared.getLocation()
                if let loc = location{
                    self.mkMapView.centerToLocation(loc, regionRadius: self.radius)
                }
            }
            LocationService.shared.delegate = self
        }
        else{
            showError("locationNotAuthorized")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        LocationService.shared.delegate = nil
    }
    
    func setNeedsUpdate(){
        if mapLoaded{
            mkMapView.removeAnnotations(mkMapView.annotations)
            assertMapPins()
        }
    }
    
    func assertMapPins(){
        for day in GlobalData.shared.days{
            for entry in day.entries{
                if entry.showLocation, let loc = entry.location{
                    let positionPin = EntryAnnotation(entry: entry)
                    positionPin.title = entry.creationDate.dateTimeString()
                    positionPin.coordinate = loc.coordinate
                    mkMapView.addAnnotation(positionPin)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        if let annotation = view.annotation as? EntryAnnotation{
            let entryController = EntryViewController()
            entryController.entry = annotation.entry
            entryController.modalPresentationStyle = .fullScreen
            self.present(entryController, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = self.tileOverlay{
            return MKTileOverlayRenderer(tileOverlay: overlay)
        }
        return MKTileOverlayRenderer()
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        mapLoaded = true
        assertMapPins()
    }
    
    @objc func showInfo(){
        let infoController = MapInfoViewController()
        self.present(infoController, animated: true)
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
        if let overlay = tileOverlay {
            mkMapView.removeOverlay(overlay)
            self.tileOverlay = nil
        }
        switch mapType{
        case .apple:
            mkMapView.mapType = .standard
        case .osm:
            mkMapView.mapType = .standard
            tileOverlay = MKTileOverlay(urlTemplate: Settings.osmUrl)
            tileOverlay!.canReplaceMapContent = true
            mkMapView.addOverlay(tileOverlay!)
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
