/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class EditEntryInfoViewController: InfoViewController {
    
    let headerText = InfoHeader(text: "editEntryInfoHeader".localize())
    let topText = InfoText(text: "editEntryTopInfo".localize())
    let iconTextInfo = IconInfoText(icon: "text.alignleft", text: "timelineTextIconInfo".localize())
    let iconImageInfo = IconInfoText(icon: "camera", text: "timelineImageIconInfo".localize())
    let iconAudioInfo = IconInfoText(icon: "mic", text: "timelineAudioIconInfo".localize())
    let iconVideoInfo = IconInfoText(icon: "video", text: "timelineVideoIconInfo".localize())
    let iconMapInfo = IconInfoText(icon: "map", text: "timelineMapIconInfo".localize())
    let itemHeaderText = InfoHeader(text: "editEntryItemInfoHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let iconDeleteInfo = IconInfoText(icon: "xmark.circle", text: "editEntryDeleteIconInfo".localize(),iconColor: .systemRed)
    let othersHeaderText = InfoHeader(text: "editEntryOthersHeader".localize(), paddingTop: 2 * Insets.defaultInset)
    let iconToggleCameraInfo = IconInfoText(icon: "camera.rotate", text: "editEntryToggleCameraIconInfo".localize())
    let iconFlashCameraInfo = IconInfoText(icon: "flash", text: "editEntryFlashIconInfo".localize())
    let iconToggleMapInfo = IconInfoText(icon: "map", text: "editEntryToggleMapIconInfo".localize())
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(headerText)
        stackView.addArrangedSubview(topText)
        stackView.addArrangedSubview(iconTextInfo)
        stackView.addArrangedSubview(iconImageInfo)
        stackView.addArrangedSubview(iconAudioInfo)
        stackView.addArrangedSubview(iconVideoInfo)
        stackView.addArrangedSubview(iconMapInfo)
        stackView.addArrangedSubview(itemHeaderText)
        stackView.addArrangedSubview(iconDeleteInfo)
        stackView.addArrangedSubview(othersHeaderText)
        stackView.addArrangedSubview(iconToggleCameraInfo)
        stackView.addArrangedSubview(iconFlashCameraInfo)
        stackView.addArrangedSubview(iconToggleMapInfo)
    }
    
}
