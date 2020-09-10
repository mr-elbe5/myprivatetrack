//
//  ModalViewController.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

open class ModalViewController: ViewController {
    
    public var stackView = UIStackView()
    
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
        closeButton.setAnchors()
            .top(buttonView.topAnchor,inset: defaultInset)
            .trailing(buttonView.trailingAnchor,inset: defaultInset)
            .bottom(buttonView.bottomAnchor,inset: defaultInset)
        headerView = buttonView
    }
    
    @objc public func close(){
        self.dismiss(animated: true, completion: {
        })
    }
    
}
