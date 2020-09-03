//
//  AppInfoViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 03.09.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class AppInfoViewController: ScrollViewController {
    
    public var stackView = UIStackView()
    
    let privacyHeader = InfoHeader(text: "privacyInfoHeader".localize())
    let privacyInfoText = InfoText(text: "privacyInfoText".localize())
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
        stackView.setupVertical()
        stackView.addArrangedSubview(privacyHeader)
        stackView.addArrangedSubview(privacyInfoText)
    }
    
    
}
