/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class InfoViewController: ScrollViewController {
    
    var generalStackView = UIStackView()
    var timelineStackView = UIStackView()
    var entryStackView = UIStackView()
    var cameraStackView = UIStackView()
    var mapStackView = UIStackView()
    var settingsStackView = UIStackView()
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
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
        timelineStackView.addArrangedSubview(InfoHeader(text: "timelineEntryInfoHeader".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "magnifyingglass", text: "timelineDetailIconInfo".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "map", text: "timelineMapIconInfo".localize()))
        timelineStackView.addArrangedSubview(InfoHeader(text: "timelineInfoEditHeader".localize()))
        timelineStackView.addArrangedSubview(IconInfoText(icon: "trash", text: "timelineDeleteIconInfo".localize(), iconColor: .systemRed))
        timelineStackView.addArrangedSubview(InfoText(text: "timelineQuicktextInfo".localize()))
        
        //entries
        
        header = InfoHeader(text: "entryInfoHeader".localize())
        scrollView.addSubview(header)
        header.setAnchors(top: timelineStackView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        scrollView.addSubview(entryStackView)
        entryStackView.setupVertical()
        entryStackView.setAnchors(top: header.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        entryStackView.addArrangedSubview(InfoHeader(text: "editEntryInfoHeader".localize()))
        entryStackView.addArrangedSubview(InfoText(text: "editEntryTopInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "text.bubble", text: "entryTextIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "camera", text: "entryPhotoIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "photo", text: "entryImageIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "mic", text: "entryAudioIconInfo".localize()))
        entryStackView.addArrangedSubview(IconInfoText(icon: "video", text: "entryVideoIconInfo".localize()))
        entryStackView.addArrangedSubview(InfoHeader(text: "editEntryItemInfoHeader".localize(), paddingTop: 2 * Insets.defaultInset))
        entryStackView.addArrangedSubview(IconInfoText(icon: "trash", text: "editEntryDeleteIconInfo".localize(),iconColor: .systemRed))
        entryStackView.addArrangedSubview(IconInfoText(icon: "square.and.arrow.up", text: "timelineShareIconInfo".localize()))
        entryStackView.addArrangedSubview(InfoHeader(text: "timelineEntryInfoHeader".localize(), paddingTop: 2 * Insets.defaultInset))
        entryStackView.addArrangedSubview(InfoHeader(text: "timelineInfoEditHeader".localize(), paddingTop: 2 * Insets.defaultInset))
        entryStackView.addArrangedSubview(InfoText(text: "timelineEditInfo".localize()))
        
        header = InfoHeader(text: "cameraInfoHeader".localize())
        scrollView.addSubview(header)
        header.setAnchors(top: entryStackView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        scrollView.addSubview(cameraStackView)
        cameraStackView.setupVertical()
        cameraStackView.setAnchors(top: header.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        cameraStackView.addArrangedSubview(IconInfoText(icon: "camera.rotate", text: "editEntryToggleCameraIconInfo".localize()))
        cameraStackView.addArrangedSubview(IconInfoText(icon: "flash", text: "editEntryFlashIconInfo".localize()))
        
        
        //map
        
        header = InfoHeader(text: "mapInfoHeader".localize())
        scrollView.addSubview(header)
        header.setAnchors(top: cameraStackView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        scrollView.addSubview(mapStackView)
        mapStackView.setupVertical()
        mapStackView.setAnchors(top: header.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        mapStackView.addArrangedSubview(InfoHeader(text: "mapInfoHeader".localize()))
        mapStackView.addArrangedSubview(InfoText(text: "mapTopInfo".localize()))
        
        // settings
        
        header = InfoHeader(text: "settingsInfoHeader".localize())
        scrollView.addSubview(header)
        header.setAnchors(top: mapStackView.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, insets: defaultInsets)
        scrollView.addSubview(settingsStackView)
        settingsStackView.setupVertical()
        settingsStackView.setAnchors(top: header.bottomAnchor, leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, bottom: scrollView.bottomAnchor, insets: defaultInsets)
        settingsStackView.addArrangedSubview(InfoText(text: "settingsBackgroundInfo".localize()))
        settingsStackView.addArrangedSubview(InfoHeader(text: "entries".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsResetInfo".localize()))
        settingsStackView.addArrangedSubview(InfoHeader(text: "privacyExportHeader".localize()))
        settingsStackView.addArrangedSubview(InfoHeader(text: "backup".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "backupInfo".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsFullBackupInfo".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsPartialBackupInfo".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsRestoreInfo".localize()))
        settingsStackView.addArrangedSubview(InfoHeader(text: "restore".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "restoreInfo".localize()))
        settingsStackView.addArrangedSubview(InfoHeader(text: "files".localize()))
        settingsStackView.addArrangedSubview(InfoText(text: "settingsFilesInfo".localize()))
        
    }
    
    
}
