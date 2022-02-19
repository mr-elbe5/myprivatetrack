/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

protocol TimelineEntryCellDelegate: ImageItemDelegate, VideoItemDelegate{
    func deleteEntry(entry: EntryData)
    func viewEntry(entry: EntryData)
}

class TimelineEntryCell: UITableViewCell{
    
    var entry : EntryData? = nil {
        didSet {
            updateCell()
        }
    }
    
    var delegate: TimelineEntryCellDelegate? = nil
    
    var cellBody = CellBody()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        backgroundColor = .clear
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCell(isEditing: Bool = false){
        contentView.removeAllSubviews()
        cellBody = CellBody()
        cellBody.setup()
        contentView.addSubview(cellBody)
        cellBody.fillView(view: contentView, insets: defaultInsets)
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
                    .iconHeight()
                if entry.location != nil{
                    let mapButton = IconButton(icon: "map")
                    mapButton.addTarget(self, action: #selector(showInMap), for: .touchDown)
                    cellBody.addSubview(mapButton)
                    mapButton.setAnchors(top: cellBody.topAnchor, trailing: viewButton.leadingAnchor, insets: smallInsets)
                        .iconHeight()
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
                case .photo, .image, .video:
                    items.append(item)
                }
            }
            if items.count > 0{
                let mediaView = PreviewContainer()
                cellBody.addSubview(mediaView)
                mediaView.setAnchors(top: lastView.bottomAnchor, leading: cellBody.leadingAnchor, trailing: cellBody.trailingAnchor, insets: defaultInsets)
                for item in items{
                    switch item.type{
                    case .photo, .image:
                        mediaView.previews.append(ImageItemPreview.previewFromData(data: item.data as! ImageItemData, delegate: isEditing ? nil : self))
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
    
}

extension TimelineEntryCell: ImageItemDelegate, VideoItemDelegate{
    
    func viewImageItem(data: ImageItemData){
        delegate?.viewImageItem(data: data)
    }
    
    func shareImageItem(data: ImageItemData){
        delegate?.shareImageItem(data: data)
    }
    
    func viewVideoItem(data: VideoItemData){
        delegate?.viewVideoItem(data: data)
    }
    
    func shareVideoItem(data: VideoItemData){
        delegate?.shareVideoItem(data: data)
    }
    
}

class CellBody : UIView{
    
    func setup(){
        backgroundColor = transparentColor
        layer.cornerRadius = 5
    }
    
}
