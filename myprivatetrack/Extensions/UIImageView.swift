//
//  UIImageView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 30.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView{
    
    @objc func setDefaults(){
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
    }
    
    func setAspectRatioConstraint() {
        if let imageSize = image?.size, imageSize.height != 0
        {
            let aspectRatio = imageSize.width / imageSize.height
            let c = NSLayoutConstraint(item: self, attribute: .width,
                                       relatedBy: .equal,
                                       toItem: self, attribute: .height,
                                       multiplier: aspectRatio, constant: 0)
            c.priority = UILayoutPriority(900)
            self.addConstraint(c)
        }
    }
    
}


