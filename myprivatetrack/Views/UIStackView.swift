//
//  UIStackView.swift
//
//  Created by Michael Rönnau on 11.07.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView{
    
    public func setupVertical(spacing: CGFloat = 0){
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .equalSpacing
        self.spacing = spacing
    }
    
    public func setupHorizontal(distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 0){
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = distribution
        self.spacing = spacing
    }
    
    public func removeAllArrangedSubviews() {
        for subview in subviews {
            removeArrangedSubview(subview)
        }
        removeAllSubviews()
    }

}
