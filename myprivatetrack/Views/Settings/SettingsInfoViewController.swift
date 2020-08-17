//
//  SettingsInfoViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
class SettingsInfoViewController: ModalScrollViewController {
    
    let useLocationHeader = InfoHeader(text: "useLocation".localize())
    let useLocationText = InfoText(text: "settingsUseLocationInfo".localize())
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(useLocationHeader)
        stackView.addArrangedSubview(useLocationText)
        
    }
    
    
}
