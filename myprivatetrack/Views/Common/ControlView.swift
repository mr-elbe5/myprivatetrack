//
//  ControlView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 04.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class ControlView: UIView{
    
    var stackView = UIStackView()
    
    func setupView(){
        addSubview(stackView)
    }
    
}

class RightHorizonalControlView: ControlView{
    
    override func setupView(){
        super.setupView()
        stackView.setupHorizontal(spacing: defaultInset)
        stackView.placeBefore(anchor: trailingAnchor, padding: defaultInsets)
    }
    
}
