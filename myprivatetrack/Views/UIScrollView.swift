//
//  UIScrollView.swift
//
//  Created by Michael Rönnau on 14.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView{
    
    public func setupVertical(){
        self.isScrollEnabled = true
        let scflg = self.contentLayoutGuide
        let svflg = self.frameLayoutGuide
        scflg.widthAnchor.constraint(equalTo: svflg.widthAnchor).isActive = true
    }
    
}
