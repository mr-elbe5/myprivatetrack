//
//  ModalViewController.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

open class ModalViewController: ViewController {
    
    var stackView = UIStackView()
    
    override open func loadView() {
        self.mainViewTopPadding = 0
        super.loadView()
    }
    
    override open func setupHeaderView(){
        let buttonView = UIView()
        buttonView.backgroundColor = UIColor.systemBackground
        let closeButton = IconButton(icon: "xmark.circle")
        buttonView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        closeButton.setAnchors(top: buttonView.topAnchor, trailing: buttonView.trailingAnchor, bottom: buttonView.bottomAnchor, insets: defaultInsets)
        headerView = buttonView
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: {
        })
    }
    
}
