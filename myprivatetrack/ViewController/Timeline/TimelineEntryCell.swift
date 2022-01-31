//
//  EntryCell.swift
//
//  Created by Michael Rönnau on 15.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

protocol EntryCellActionDelegate{
    func editEntry(entry: EntryData)
    func deleteEntry(entry: EntryData)
    func viewEntry(entry: EntryData)
    func viewPhotoItem(data: PhotoItemData)
    func sharePhotoItem(data: PhotoItemData)
    func viewVideoItem(data: VideoItemData)
    func shareVideoItem(data: VideoItemData)
}

class TimelineEntryCell: UITableViewCell, PhotoItemDelegate, VideoItemDelegate{
    
    var entry : EntryData? = nil {
        didSet {
            updateCell()
        }
    }
    
    var delegate: EntryCellActionDelegate? = nil
    
    var cellBody = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        backgroundColor = .clear
        cellBody.backgroundColor = transparentColor
        cellBody.layer.cornerRadius = 5
        contentView.addSubview(cellBody)
        cellBody.fillView(view: contentView, insets: defaultInsets)
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isEditing: Bool = false){
        cellBody.backgroundColor = transparentColor
        cellBody.removeAllSubviews()
        if entry != nil{
            let timeLabel = UILabel()
            timeLabel.text = entry!.creationDate.timeString()
            timeLabel.textAlignment = .center
            cellBody.addSubview(timeLabel)
            timeLabel.setAnchors(top: cellBody.topAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            var lastView : UIView = timeLabel
            if entry!.showLocation, let loc = entry!.location{
                let locationButton = TextButton(text: loc.asString)
                locationButton.addTarget(self,action: #selector(showInMap), for: .touchDown)
                cellBody.addSubview(locationButton)
                locationButton.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                lastView = locationButton
                let desc = entry!.locationDescription
                if !desc.isEmpty{
                    let locationDescriptionLabel = UILabel()
                    locationDescriptionLabel.text = desc
                    locationDescriptionLabel.textAlignment = .center
                    cellBody.addSubview(locationDescriptionLabel)
                    locationDescriptionLabel.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                    lastView = locationDescriptionLabel
                }
                /*if entry!.hasMapSection{
                    let mapView = MapItemView()
                    mapView.setupView(data: entry!)
                    cellBody.addSubview(mapView)
                    mapView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                    lastView = mapView
                }*/
            }
            if isEditing{
                let deleteButton = IconButton(icon: "xmark.circle")
                deleteButton.tintColor = UIColor.systemRed
                deleteButton.addTarget(self, action: #selector(deleteEntry), for: .touchDown)
                cellBody.addSubview(deleteButton)
                deleteButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                
                let editButton = IconButton(icon: "pencil.circle")
                editButton.tintColor = UIColor.systemBlue
                editButton.addTarget(self, action: #selector(editEntry), for: .touchDown)
                cellBody.addSubview(editButton)
                editButton.setAnchors(top: cellBody.topAnchor, trailing: deleteButton.leadingAnchor, insets: defaultInsets)
            }
            else{
                let viewButton = IconButton(icon: "magnifyingglass", tintColor: .systemBlue)
                viewButton.addTarget(self, action: #selector(viewEntry), for: .touchDown)
                cellBody.addSubview(viewButton)
                viewButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: doubleInsets)
            }
            
            for item in entry!.items{
                switch item.type{
                case .text:
                    let itemView = TextItemView.fromData(data: item.data as! TextItemData)
                    cellBody.addSubview(itemView)
                    itemView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                    lastView = itemView
                    break
                case .audio:
                    let itemView = AudioItemView.fromData(data: item.data as! AudioData)
                    cellBody.addSubview(itemView)
                    itemView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                    lastView = itemView
                    break
                case .photo:
                    let itemView = PhotoItemView.fromData(data: item.data as! PhotoItemData, delegate: self)
                    cellBody.addSubview(itemView)
                    itemView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                    lastView = itemView
                    break
                case .video:
                    let itemView = VideoItemView.fromData(data: item.data as! VideoItemData, delegate: self)
                    cellBody.addSubview(itemView)
                    itemView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                    lastView = itemView
                    break
                }
            }
            lastView.bottom(cellBody.bottomAnchor, inset: -defaultInset)
        }
    }
    
    @objc func showInMap(){
        if let location = entry?.location{
            let mapController = MainTabController.getMapViewController()
            mapController?.mkMapView.centerToLocation(location, regionRadius: 1000)
            MainTabController.instance.selectedViewController = mapController
        }
    }
    
    @objc func editEntry() {
        if entry != nil{
            delegate?.editEntry(entry: entry!)
        }
    }
    
    @objc func deleteEntry() {
        if entry != nil{
            delegate?.deleteEntry(entry: entry!)
        }
    }
    
    @objc func viewEntry(){
        if entry != nil{
            delegate?.viewEntry(entry: entry!)
        }
    }
    
    func viewPhotoItem(data: PhotoItemData){
        delegate?.viewPhotoItem(data: data)
    }
    
    func sharePhotoItem(data: PhotoItemData){
        delegate?.sharePhotoItem(data: data)
    }
    
    func viewVideoItem(data: VideoItemData){
        delegate?.viewVideoItem(data: data)
    }
    
    func shareVideoItem(data: VideoItemData){
        delegate?.shareVideoItem(data: data)
    }
    
}
