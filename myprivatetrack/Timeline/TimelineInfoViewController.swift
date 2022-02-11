/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class TimelineInfoViewController: InfoViewController {
    
    let headerText = InfoHeader(text: "timelineInfoHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let topText = InfoText(text: "timelineTopInfo".localize())
    let locationText = InfoText(text: "timelineLocationInfo".localize())
    let iconTextInfo = IconInfoText(icon: "text.alignleft", text: "timelineTextIconInfo".localize())
    let iconPhotoInfo = IconInfoText(icon: "camera", text: "timelinePhotoIconInfo".localize())
    let iconImageInfo = IconInfoText(icon: "photo", text: "timelineImageIconInfo".localize())
    let iconAudioInfo = IconInfoText(icon: "mic", text: "timelineAudioIconInfo".localize())
    let iconVideoInfo = IconInfoText(icon: "video", text: "timelineVideoIconInfo".localize())
    let entryHeaderText = InfoHeader(text: "timelineEntryInfoHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let mapLinkText = InfoText(text: "timelineEntryMapLinkInfo".localize())
    let detailInfo = IconInfoText(icon: "magnifyingglass", text: "timelineDetailIconInfo".localize())
    let mapInfo = IconInfoText(icon: "map", text: "timelineMapIconInfo".localize())
    let editHeaderText = InfoHeader(text: "timelineInfoEditHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let editText = InfoText(text: "timelineEditInfo".localize())
    let iconDeleteInfo = IconInfoText(icon: "trash", text: "timelineDeleteIconInfo".localize(), iconColor: .systemRed)
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(headerText)
        stackView.addArrangedSubview(topText)
        stackView.addArrangedSubview(locationText)
        stackView.addArrangedSubview(iconTextInfo)
        stackView.addArrangedSubview(iconPhotoInfo)
        stackView.addArrangedSubview(iconImageInfo)
        stackView.addArrangedSubview(iconAudioInfo)
        stackView.addArrangedSubview(iconVideoInfo)
        stackView.addArrangedSubview(entryHeaderText)
        stackView.addArrangedSubview(mapLinkText)
        stackView.addArrangedSubview(detailInfo)
        stackView.addArrangedSubview(mapInfo)
        stackView.addArrangedSubview(editHeaderText)
        stackView.addArrangedSubview(editText)
        stackView.addArrangedSubview(iconDeleteInfo)
    }
    
    
}
