//
//  EntryCell.swift
//
//  Created by Michael Rönnau on 15.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

protocol EntryCellActionDelegate{
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
        if let entry = entry{
            let timeLabel = UILabel()
            timeLabel.text = entry.creationDate.timeString()
            timeLabel.textAlignment = .center
            cellBody.addSubview(timeLabel)
            timeLabel.setAnchors(top: cellBody.topAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
            var lastView : UIView = timeLabel
            if entry.showLocation, let loc = entry.location{
                let locationLabel = UILabel()
                locationLabel.text = entry.locationDescription.isEmpty ? loc.asString : entry.locationDescription
                locationLabel.textAlignment = .center
                cellBody.addSubview(locationLabel)
                locationLabel.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: flatInsets)
                lastView = locationLabel
            }
            if isEditing{
                let deleteButton = IconButton(icon: "trash", tintColor: .systemRed)
                deleteButton.addTarget(self, action: #selector(deleteEntry), for: .touchDown)
                cellBody.addSubview(deleteButton)
                deleteButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: smallInsets)
            }
            else{
                let viewButton = IconButton(icon: "magnifyingglass")
                viewButton.addTarget(self, action: #selector(viewEntry), for: .touchDown)
                cellBody.addSubview(viewButton)
                viewButton.setAnchors(top: cellBody.topAnchor, trailing: cellBody.trailingAnchor, insets: smallInsets)
                if entry.location != nil{
                    let mapButton = IconButton(icon: "map")
                    mapButton.addTarget(self, action: #selector(showInMap), for: .touchDown)
                    cellBody.addSubview(mapButton)
                    mapButton.setAnchors(top: cellBody.topAnchor, trailing: viewButton.leadingAnchor, insets: smallInsets)
                }
            }
            var items = Array<EntryItem>()
            for item in entry.items{
                switch item.type{
                case .text:
                    let itemView = TextItemView.fromData(data: item.data as! TextItemData)
                    cellBody.addSubview(itemView)
                    itemView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                    lastView = itemView
                case .audio:
                    let itemView = AudioItemView.fromData(data: item.data as! AudioData)
                    cellBody.addSubview(itemView)
                    itemView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                    lastView = itemView
                case .photo, .video:
                    items.append(item)
                }
            }
            if items.count > 0{
                let mediaView = PreviewContainer()
                cellBody.addSubview(mediaView)
                mediaView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                for item in items{
                    switch item.type{
                    case .photo:
                        mediaView.previews.append(PhotoItemPreview.previewFromData(data: item.data as! PhotoItemData, delegate: isEditing ? nil : self))
                    case .video:
                        mediaView.previews.append(VideoItemPreview.previewFromData(data: item.data as! VideoItemData, delegate: isEditing ? nil : self))
                    default:
                        continue
                    }
                }
                mediaView.setupPreviews()
                lastView = mediaView
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
