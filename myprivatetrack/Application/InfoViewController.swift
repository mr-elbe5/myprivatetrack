/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class InfoViewController: ScrollViewController {
    
    var stackView = UIStackView()
    
    let privacyHeader = InfoHeader(text: "privacyInfoHeader".localize())
    let privacyInfoText1 = InfoText(text: "privacyInfoText1".localize())
    let privacyInfoText2 = InfoText(text: "privacyInfoText2".localize())
    let privacyInfoText3 = InfoText(text: "privacyInfoText3".localize())
    let privacyInfoText4 = InfoText(text: "privacyInfoText4".localize())
    let privacyInfoText5 = InfoText(text: "privacyInfoText5".localize())
    let privacyInfoText6 = InfoText(text: "privacyInfoText6".localize())
    let exportHeader = InfoHeader(text: "privacyExportHeader".localize())
    let exportInfoText = InfoText(text: "privacyExportText".localize())
    let iconsHeaderText = InfoHeader(text: "iconsInfoHeader".localize())
    
    let settingsHeader = InfoHeader(text: "settings".localize())
    let backgroundText = InfoText(text: "settingsBackgroundInfo".localize())
    let mapSizeText = InfoText(text: "settingsMapSizeInfo".localize())
    let entriesHeader = InfoHeader(text: "entries".localize())
    let resetText = InfoText(text: "settingsResetInfo".localize())
    let fullBackupText = InfoText(text: "settingsFullBackupInfo".localize())
    let partialBackupText = InfoText(text: "settingsPartialBackupInfo".localize())
    let settingsRestoreText = InfoText(text: "settingsRestoreInfo".localize())
    let filesHeader = InfoHeader(text: "files".localize())
    let filesText = InfoText(text: "settingsFilesInfo".localize())
    
    let timelineHeaderText = InfoHeader(text: "timelineInfoHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let timelineTopText = InfoText(text: "timelineTopInfo".localize())
    let timelineLocationText = InfoText(text: "timelineLocationInfo".localize())
    let timelineIconTextInfo = IconInfoText(icon: "text.alignleft", text: "timelineTextIconInfo".localize())
    let timelineIconPhotoInfo = IconInfoText(icon: "camera", text: "timelinePhotoIconInfo".localize())
    let timelineIconImageInfo = IconInfoText(icon: "photo", text: "timelineImageIconInfo".localize())
    let timelineIconAudioInfo = IconInfoText(icon: "mic", text: "timelineAudioIconInfo".localize())
    let timelineIconVideoInfo = IconInfoText(icon: "video", text: "timelineVideoIconInfo".localize())
    let entryHeaderText = InfoHeader(text: "timelineEntryInfoHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let mapLinkText = InfoText(text: "timelineEntryMapLinkInfo".localize())
    let detailInfo = IconInfoText(icon: "magnifyingglass", text: "timelineDetailIconInfo".localize())
    let mapInfo = IconInfoText(icon: "map", text: "timelineMapIconInfo".localize())
    let editHeaderText = InfoHeader(text: "timelineInfoEditHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let editText = InfoText(text: "timelineEditInfo".localize())
    let timelineIconDeleteInfo = IconInfoText(icon: "trash", text: "timelineDeleteIconInfo".localize(), iconColor: .systemRed)
    
    let headerText = InfoHeader(text: "editEntryInfoHeader".localize())
    let topText = InfoText(text: "editEntryTopInfo".localize())
    let iconTextInfo = IconInfoText(icon: "text.bubble", text: "timelineTextIconInfo".localize())
    let iconPhotoInfo = IconInfoText(icon: "camera", text: "timelinePhotoIconInfo".localize())
    let iconImageInfo = IconInfoText(icon: "photo", text: "timelineImageIconInfo".localize())
    let iconAudioInfo = IconInfoText(icon: "mic", text: "timelineAudioIconInfo".localize())
    let iconVideoInfo = IconInfoText(icon: "video", text: "timelineVideoIconInfo".localize())
    let itemHeaderText = InfoHeader(text: "editEntryItemInfoHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let iconDeleteInfo = IconInfoText(icon: "trash", text: "editEntryDeleteIconInfo".localize(),iconColor: .systemRed)
    let iconToggleCameraInfo = IconInfoText(icon: "camera.rotate", text: "editEntryToggleCameraIconInfo".localize())
    let iconFlashCameraInfo = IconInfoText(icon: "flash", text: "editEntryFlashIconInfo".localize())
    let shareInfo = IconInfoText(icon: "square.and.arrow.up", text: "timelineShareIconInfo".localize())
    
    let backupHeader = InfoHeader(text: "backup".localize())
    let backupText = InfoText(text: "backupInfo".localize())
    
    let mapHeaderText = InfoHeader(text: "mapInfoHeader".localize())
    let mapTopText = InfoText(text: "mapTopInfo".localize())
    
    let restoreHeader = InfoHeader(text: "restore".localize())
    let restoreText = InfoText(text: "restoreInfo".localize())
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillView(view: scrollView, insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        stackView.addArrangedSubview(privacyHeader)
        stackView.addArrangedSubview(privacyInfoText1)
        stackView.addArrangedSubview(privacyInfoText2)
        stackView.addArrangedSubview(privacyInfoText3)
        stackView.addArrangedSubview(privacyInfoText4)
        stackView.addArrangedSubview(privacyInfoText5)
        stackView.addArrangedSubview(privacyInfoText6)
        stackView.addArrangedSubview(exportHeader)
        stackView.addArrangedSubview(exportInfoText)
        stackView.addArrangedSubview(iconsHeaderText)
        stackView.addArrangedSubview(iconTextInfo)
        stackView.addArrangedSubview(iconPhotoInfo)
        stackView.addArrangedSubview(iconImageInfo)
        stackView.addArrangedSubview(iconAudioInfo)
        stackView.addArrangedSubview(iconVideoInfo)
        stackView.addArrangedSubview(iconDeleteInfo)
        stackView.addArrangedSubview(iconToggleCameraInfo)
        stackView.addArrangedSubview(iconFlashCameraInfo)
        
        stackView.addArrangedSubview(settingsHeader)
        stackView.addArrangedSubview(backgroundText)
        stackView.addArrangedSubview(mapSizeText)
        stackView.addArrangedSubview(entriesHeader)
        stackView.addArrangedSubview(resetText)
        stackView.addArrangedSubview(fullBackupText)
        stackView.addArrangedSubview(partialBackupText)
        stackView.addArrangedSubview(settingsRestoreText)
        stackView.addArrangedSubview(filesHeader)
        stackView.addArrangedSubview(filesText)
        
        stackView.addArrangedSubview(timelineHeaderText)
        stackView.addArrangedSubview(timelineTopText)
        stackView.addArrangedSubview(timelineLocationText)
        stackView.addArrangedSubview(timelineIconTextInfo)
        stackView.addArrangedSubview(timelineIconPhotoInfo)
        stackView.addArrangedSubview(timelineIconImageInfo)
        stackView.addArrangedSubview(timelineIconAudioInfo)
        stackView.addArrangedSubview(timelineIconVideoInfo)
        stackView.addArrangedSubview(entryHeaderText)
        stackView.addArrangedSubview(mapLinkText)
        stackView.addArrangedSubview(detailInfo)
        stackView.addArrangedSubview(mapInfo)
        stackView.addArrangedSubview(editHeaderText)
        stackView.addArrangedSubview(editText)
        stackView.addArrangedSubview(timelineIconDeleteInfo)
        
        stackView.addArrangedSubview(headerText)
        stackView.addArrangedSubview(topText)
        stackView.addArrangedSubview(iconTextInfo)
        stackView.addArrangedSubview(iconPhotoInfo)
        stackView.addArrangedSubview(iconImageInfo)
        stackView.addArrangedSubview(iconAudioInfo)
        stackView.addArrangedSubview(iconVideoInfo)
        stackView.addArrangedSubview(itemHeaderText)
        stackView.addArrangedSubview(iconDeleteInfo)
        stackView.addArrangedSubview(iconToggleCameraInfo)
        stackView.addArrangedSubview(iconFlashCameraInfo)
        
        stackView.addArrangedSubview(backupHeader)
        stackView.addArrangedSubview(backupText)
        
        stackView.addArrangedSubview(mapHeaderText)
        stackView.addArrangedSubview(mapTopText)
        
        stackView.addArrangedSubview(restoreHeader)
        stackView.addArrangedSubview(restoreText)
    }
    
    
}
