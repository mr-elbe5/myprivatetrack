//
//  SettingsInfoViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class SettingsInfoViewController: InfoViewController {
    
    let useLocationHeader = InfoHeader(text: "useLocation".localize())
    let useLocationText = InfoText(text: "settingsUseLocationInfo".localize())
    let resetText = InfoText(text: "settingsResetInfo".localize())
    let passwordText = InfoText(text: "settingsPasswordInfo".localize())
    let backupText = InfoText(text: "settingsBackupInfo".localize())
    let restoreText = InfoText(text: "settingsRestoreInfo".localize())
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(useLocationHeader)
        stackView.addArrangedSubview(useLocationText)
        stackView.addArrangedSubview(resetText)
        stackView.addArrangedSubview(passwordText)
        stackView.addArrangedSubview(backupText)
        stackView.addArrangedSubview(restoreText)
    }
    
    
}
