//
//  ImportInfoViewController.swift
//
//  Created by Michael Rönnau on 28.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation

class RestoreInfoViewController: InfoViewController {
    
    let restoreHeader = InfoHeader(text: "restore".localize())
    let restoreText = InfoText(text: "restoreInfo".localize())
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(restoreHeader)
        stackView.addArrangedSubview(restoreText)
    }
    
    
}
