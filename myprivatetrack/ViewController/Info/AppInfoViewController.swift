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
    
    override func loadView() {
        super.loadView()
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillSuperview(insets: UIEdgeInsets(top: defaultInset, left: .zero, bottom: defaultInset, right: .zero))
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
    }
    
    
}
