//
//  EditEntryInfoViewController.swift
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class EditEntryInfoViewController: InfoViewController {
    
    let headerText = InfoHeader(text: "editEntryInfoHeader".localize())
    let topText = InfoText(text: "editEntryTopInfo".localize())
    let iconTextInfo = IconInfoText(image: "text-entry", text: "editEntryTextIconInfo".localize())
    let iconImageInfo = IconInfoText(image: "photo-entry", text: "editEntryImageIconInfo".localize())
    let iconAudioInfo = IconInfoText(image: "audio-entry", text: "editEntryAudioIconInfo".localize())
    let iconVideoInfo = IconInfoText(image: "video-entry", text: "editEntryVideoIconInfo".localize())
    let itemHeaderText = InfoHeader(text: "editEntryItemInfoHeader".localize(), paddingTop: 2 * Statics.defaultInset)
    let iconDeleteInfo = IconInfoText(icon: "xmark.circle", text: "editEntryDeleteIconInfo".localize(),iconColor: .systemRed)
    let othersHeaderText = InfoHeader(text: "editEntryOthersHeader".localize(), paddingTop: 2 * Statics.defaultInset)
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
        stackView.addArrangedSubview(itemHeaderText)
        stackView.addArrangedSubview(iconDeleteInfo)
        stackView.addArrangedSubview(othersHeaderText)
        stackView.addArrangedSubview(iconToggleCameraInfo)
        stackView.addArrangedSubview(iconFlashCameraInfo)
        stackView.addArrangedSubview(iconToggleMapInfo)
    }
    
}
