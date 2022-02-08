//
//  TextButton.swift
//
//  Created by Michael Rönnau on 08.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class TextButton : UIButton{
    
    init(text: String, tintColor: UIColor = .systemBlue, backgroundColor: UIColor? = nil){
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        setTitleColor(tintColor, for: .normal)
        self.tintColor = tintColor
        if let bgcol = backgroundColor{
            self.backgroundColor = bgcol
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return getExtendedIntrinsicContentSize(originalSize: super.intrinsicContentSize)
    }
    
}
