/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class InfoViewController: ScrollViewController {
    
    var headerView = UIView()
    
    var generalStackView = UIStackView()
    var timelineStackView = UIStackView()
    var entryStackView = UIStackView()
    var cameraStackView = UIStackView()
    var mapStackView = UIStackView()
    var settingsStackView = UIStackView()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        let guide = view.safeAreaLayoutGuide
        view.addSubview(headerView)
        headerView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: .zero)
        setupScrollView()
        scrollView.setAnchors(leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: .zero)
            .top(headerView.bottomAnchor, inset: 1)
        scrollView.addSubview(generalStackView)
        var header = InfoHeader(text: "generalInfoHeader".localize())
        scrollView.addSubview(header)
        header.setAnchors(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        scrollView.addSubview(generalStackView)
        generalStackView.setupVertical()
        generalStackView.setAnchors(top: header.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        generalStackView.addArrangedSubview(InfoText(text: "generalInfoText1".localize()))
        generalStackView.addArrangedSubview(InfoText(text: "generalInfoText2".localize()))
        generalStackView.addArrangedSubview(InfoText(text: "generalInfoText3".localize()))
        generalStackView.addArrangedSubview(InfoText(text: "generalInfoText4".localize()))
        generalStackView.addArrangedSubview(InfoText(text: "generalInfoText5".localize()))
        generalStackView.addArrangedSubview(InfoText(text: "generalInfoText6".localize()))
        generalStackView.addArrangedSubview(InfoText(text: "generalExportText".localize()))
        
        // timeline
        
        header = InfoHeader(text: "timelineInfoHeader".localize())
        scrollView.addSubview(header)
        header.setAnchors(top: generalStackView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        scrollView.addSubview(timelineStackView)
        timelineStackView.setupVertical()
        timelineStackView.setAnchors(top: header.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        timelineStackView.addArrangedSubview(InfoText(text: "timelineTopInfo".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "text.bubble", text: "timelineTextIconInfo".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "camera", text: "timelinePhotoIconInfo".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "photo", text: "timelineImageIconInfo".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "mic", text: "timelineAudioIconInfo".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "video", text: "timelineVideoIconInfo".localize()))
        timelineStackView.addArrangedSubview(InfoText(text: "timelineQuicktextInfo".localize()))
        timelineStackView.addArrangedSubview(InfoHeader(text: "timelineEntryInfoHeader".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "magnifyingglass", text: "timelineDetailIconInfo".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "map", text: "timelineMapIconInfo".localize()))
        timelineStackView.addArrangedSubview(InfoHeader(text: "timelineInfoEditHeader".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "trash", text: "timelineDeleteIconInfo".localize(), iconColor: .systemRed))
        
        //entries
        
        header = InfoHeader(text: "entryInfoHeader".localize())
        scrollView.addSubview(header)
        header.setAnchors(top: timelineStackView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        scrollView.addSubview(entryStackView)
        entryStackView.setupVertical()
        entryStackView.setAnchors(top: header.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        entryStackView.addArrangedSubview(InfoText(text: "entryTopInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "magnifyingglass", text: "entryDetailIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "square.and.arrow.up", text: "entryShareIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "pencil.circle", text: "editEntryInfoHeader".localize()))
        entryStackView.addArrangedSubview(InfoHeader(text: "editEntryInfoHeader".localize()))
        entryStackView.addArrangedSubview(InfoText(text: "editEntryTopInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "plus", text: "editEntryPlusIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "text.bubble", text: "editEntryTextIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "camera", text: "editEntryPhotoIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "photo", text: "editEntryImageIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "mic", text: "editEntryAudioIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "video", text: "editEntryVideoIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "trash", text: "editEntryDeleteIconInfo".localize(),iconColor: .systemRed))
        
        header = InfoHeader(text: "cameraInfoHeader".localize())
        scrollView.addSubview(header)
        header.setAnchors(top: entryStackView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        scrollView.addSubview(cameraStackView)
        cameraStackView.setupVertical()
        cameraStackView.setAnchors(top: header.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        cameraStackView.addArrangedSubview(IconInfoText(icon: "camera.rotate", text: "toggleCameraIconInfo".localize()))
        cameraStackView.addArrangedSubview(IconInfoText(icon: "bolt", text: "flashIconInfo".localize()))
        
        
        //map
        
        header = InfoHeader(text: "mapInfoHeader".localize())
        scrollView.addSubview(header)
        header.setAnchors(top: cameraStackView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        scrollView.addSubview(mapStackView)
        mapStackView.setupVertical()
        mapStackView.setAnchors(top: header.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        mapStackView.addArrangedSubview(InfoText(text: "mapTopInfo".localize()))
        mapStackView.addArrangedSubview(IconInfoText(icon: "map", text: "mapIconInfo".localize()))
        
        // settings
        
        header = InfoHeader(text: "settingsInfoHeader".localize())
        scrollView.addSubview(header)
        header.setAnchors(top: mapStackView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        scrollView.addSubview(settingsStackView)
        settingsStackView.setupVertical()
        settingsStackView.setAnchors(top: header.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: scrollView.bottomAnchor, insets: defaultInsets)
        settingsStackView.addArrangedSubview(InfoText(text: "settingsBackgroundInfo".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsUrlInfoText".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsLocationInfoText".localize()))
        settingsStackView.addArrangedSubview(InfoHeader(text: "entries".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsDeleteEntriesInfoText".localize()))
        settingsStackView.addArrangedSubview(InfoHeader(text: "backup".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsBackupInfo".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsFullBackupInfo".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsPartialBackupInfo".localize()))
        settingsStackView.addArrangedSubview(InfoHeader(text: "restore".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsRestoreInfo".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsFilesInfo".localize()))
        
    }
    
    
}
