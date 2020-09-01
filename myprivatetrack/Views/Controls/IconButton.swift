//
//  IconButton.swift
//
//  Created by Michael Rönnau on 07.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

public class IconButton : UIButton{
    
    public init(icon: String, tintColor: UIColor = .systemBlue, backgroundColor: UIColor? = nil){
        super.init(frame: .zero)
        setImage(UIImage(systemName: icon), for: .normal)
        self.tintColor = tintColor
        self.setTitleColor(tintColor, for: .normal)
        self.scaleBy(1.25)
        if let bgcol = backgroundColor{
            self.backgroundColor = bgcol
            layer.cornerRadius = 5
            layer.masksToBounds = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
