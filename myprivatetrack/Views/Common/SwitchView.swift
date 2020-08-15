//
//  SwitchView.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 15.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol SwitchDelegate{
    func valueDidChange(sender: SwitchView,isOn: Bool)
}

class SwitchView : UIView{
    
    private var label = UILabel()
    private var switcher = UISwitch()
    
    var delegate : SwitchDelegate? = nil
    
    func setupView(text: String, isOn : Bool){
        label.text = text
        addSubview(label)
        switcher.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switcher.isOn = isOn
        switcher.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
        addSubview(switcher)
        label.placeAfter(anchor: leadingAnchor)
        switcher.placeBefore(anchor: trailingAnchor)
    }
    
    @objc func valueDidChange(sender:UISwitch){
        delegate?.valueDidChange(sender: self,isOn: sender.isOn)
    }
    
}
