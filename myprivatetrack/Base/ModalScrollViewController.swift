//
//  ModalScrollViewController.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

open class ModalScrollViewController: ScrollViewController {
    
    var buttonView = UIView()
    var closeButton = IconButton(icon: "xmark.circle")
    
    override open func loadView() {
        self.scrollViewTopPadding = 0
        super.loadView()
    }
    
    override open func setupHeaderView(){
        buttonView.backgroundColor = UIColor.systemBackground
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
