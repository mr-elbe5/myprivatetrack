/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class AppInfoViewController: ScrollViewController {
    
    var stackView = UIStackView()
    
    let privacyHeader = InfoHeader(text: "privacyInfoHeader".localize())
    let privacyInfoText1 = InfoText(text: "privacyInfoText1".localize())
    let privacyInfoText2 = InfoText(text: "privacyInfoText2".localize())
    let privacyInfoText3 = InfoText(text: "privacyInfoText3".localize())
    let privacyInfoText4 = InfoText(text: "privacyInfoText4".localize())
    let privacyInfoText5 = InfoText(text: "privacyInfoText5".localize())
    let privacyInfoText6 = InfoText(text: "privacyInfoText6".localize())
    let filesHeader = InfoHeader(text: "privacyExportHeader".localize())
    let filesInfoText = InfoText(text: "privacyExportText".localize())
    let iconsHeaderText = InfoHeader(text: "iconsInfoHeader".localize())
    let iconTextInfo = IconInfoText(icon: "text.alignleft", text: "editEntryTextIconInfo".localize())
    let iconPhotoInfo = IconInfoText(icon: "camera", text: "editEntryPhotoIconInfo".localize())
    let iconImageInfo = IconInfoText(icon: "photo", text: "editEntryImageIconInfo".localize())
    let iconAudioInfo = IconInfoText(icon: "mic", text: "editEntryAudioIconInfo".localize())
    let iconVideoInfo = IconInfoText(icon: "video", text: "editEntryVideoIconInfo".localize())
    let shareInfo = IconInfoText(icon: "square.and.arrow.up", text: "timelineShareIconInfo".localize())
    let iconDeleteInfo = IconInfoText(icon: "trash", text: "editEntryDeleteIconInfo".localize(),iconColor: .systemRed)
    let iconToggleCameraInfo = IconInfoText(icon: "camera.rotate", text: "editEntryToggleCameraIconInfo".localize())
    let iconFlashCameraInfo = IconInfoText(icon: "flash", text: "editEntryFlashIconInfo".localize())
    

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
        stackView.addArrangedSubview(filesHeader)
        stackView.addArrangedSubview(filesInfoText)
        stackView.addArrangedSubview(iconsHeaderText)
        stackView.addArrangedSubview(iconTextInfo)
        stackView.addArrangedSubview(iconPhotoInfo)
        stackView.addArrangedSubview(iconImageInfo)
        stackView.addArrangedSubview(iconAudioInfo)
        stackView.addArrangedSubview(iconVideoInfo)
        stackView.addArrangedSubview(iconDeleteInfo)
        stackView.addArrangedSubview(iconToggleCameraInfo)
        stackView.addArrangedSubview(iconFlashCameraInfo)
    }
    
    
}
