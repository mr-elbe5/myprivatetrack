//
//  ControlView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 04.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

open class ControlView: UIView{
    
    public var stackView = UIStackView()
    
    public func setupView(){
        addSubview(stackView)
    }
    
}

open class RightHorizonalControlView: ControlView{
    
    override public func setupView(){
        super.setupView()
        stackView.setupHorizontal(spacing: defaultInset)
        stackView.placeBefore(anchor: trailingAnchor, padding: defaultInsets)
    }
    
}
