//
//  EditEntryInfoViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class EditEntryInfoViewController: InfoViewController {
    
    let headerText = InfoHeader(text: "editEntryInfoHeader".localize())
    let topText = InfoText(text: "editEntryTopInfo".localize())
    let iconTextInfo = IconInfoText(icon: "text.bubble", text: "editEntryTextIconInfo".localize())
    let iconImageInfo = IconInfoText(icon: "camera", text: "editEntryImageIconInfo".localize())
    let iconAudioInfo = IconInfoText(icon: "mic", text: "editEntryAudioIconInfo".localize())
    let iconVideoInfo = IconInfoText(icon: "video", text: "editEntryVideoIconInfo".localize())
    let iconMapInfo = IconInfoText(icon: "map", text: "editEntryMapIconInfo".localize())
    let itemHeaderText = InfoHeader(text: "editEntryItemInfoHeader".localize(), paddingTop: 2 * Statics.defaultInset)
    let iconDeleteInfo = IconInfoText(icon: "xmark.circle", text: "editEntryDeleteIconInfo".localize())
    let othersHeaderText = InfoHeader(text: "editEntryOthersHeader".localize(), paddingTop: 2 * Statics.defaultInset)
    let iconToggleCameraInfo = IconInfoText(icon: "camera.rotate", text: "editEntryToggleCameraIconInfo".localize())
    let iconFastCameraInfo = IconInfoText(icon: "hare", text: "editEntryFastCameraIconInfo".localize())
    let iconMediumCameraInfo = IconInfoText(icon: "gauge", text: "editEntryMediumCameraIconInfo".localize())
    let iconSlowCameraInfo = IconInfoText(icon: "tortoise", text: "editEntrySlowCameraIconInfo".localize())
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
        stackView.addArrangedSubview(iconFastCameraInfo)
        stackView.addArrangedSubview(iconMediumCameraInfo)
        stackView.addArrangedSubview(iconSlowCameraInfo)
        stackView.addArrangedSubview(iconToggleMapInfo)
    }
    
}
