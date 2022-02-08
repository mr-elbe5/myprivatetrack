//
//  DaySectionHeader.swift
//
//  Created by Michael Rönnau on 21.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class TimelineSectionHeaderLabel: UILabel {
    
    override var intrinsicContentSize: CGSize{
        return getExtendedIntrinsicContentSize(originalSize: super.intrinsicContentSize)
    }
    
}

class TimelineSectionHeader : UIView{
    
    func setupView(day: DayData){
        let label = TimelineSectionHeaderLabel()
        label.text = day.date.dateString()
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
}
