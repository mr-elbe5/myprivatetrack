//
//  ModalViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class ModalViewController: ViewController {
    
    var stackView = UIStackView()
    
    override func loadView() {
        self.mainViewTopPadding = 0
        super.loadView()
    }
    
    override func setupHeaderView(){
        let buttonView = UIView()
        buttonView.backgroundColor = UIColor.systemBackground
        let closeButton = IconButton(icon: "xmark.circle")
        buttonView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        closeButton.enableAnchors()
        closeButton.setTopAnchor(buttonView.topAnchor,padding: defaultInset)
        closeButton.setTrailingAnchor(buttonView.trailingAnchor,padding: defaultInset)
        closeButton.setBottomAnchor(buttonView.bottomAnchor,padding: defaultInset)
        headerView = buttonView
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: {
        })
    }
    
}
