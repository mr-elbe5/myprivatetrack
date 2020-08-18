//
//  MapInfoViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 12.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
class MapInfoViewController: InfoViewController {
    
    let headerText = InfoHeader(text: "mapInfoHeader".localize())
    let topText = InfoText(text: "mapTopInfo".localize())
    
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(headerText)
        stackView.addArrangedSubview(topText)
    }
    
}
