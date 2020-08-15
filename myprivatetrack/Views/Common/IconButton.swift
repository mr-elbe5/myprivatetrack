//
//  IconButton.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 07.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class IconButton : UIButton{
    
    init(icon: String, tintColor: UIColor = .systemBlue){
        super.init(frame: .zero)
        setImage(UIImage(systemName: icon), for: .normal)
        self.tintColor = tintColor
        self.setTitleColor(tintColor, for: .normal)
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
