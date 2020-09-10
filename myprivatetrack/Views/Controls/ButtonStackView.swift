//
//  ControlView.swift
//
//  Created by Michael Rönnau on 04.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

open class ButtonStackView: UIView{
    
    public var stackView = UIStackView()
    
    public func setupView(){
        addSubview(stackView)
        stackView.setupHorizontal(spacing: defaultInset)
        stackView.placeBefore(anchor: trailingAnchor, insets: defaultInsets)
    }
    
}
