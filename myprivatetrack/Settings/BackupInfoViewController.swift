//
//  ExportInfoViewController.swift
//
//  Created by Michael Rönnau on 28.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class BackupInfoViewController: InfoViewController {
    
    let backupHeader = InfoHeader(text: "backup".localize())
    let backupText = InfoText(text: "backupInfo".localize())
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(backupHeader)
        stackView.addArrangedSubview(backupText)        
    }
    
    
}
