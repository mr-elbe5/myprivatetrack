//
//  SwitchView.swift
//
//  Created by Michael Rönnau on 15.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

protocol SwitchDelegate{
    func switchValueDidChange(sender: SwitchView,isOn: Bool)
}

class SwitchView : UIView{
    
    private var label = UILabel()
    private var switcher = UISwitch()
    
    var delegate : SwitchDelegate? = nil
    
    func setupView(labelText: String, isOn : Bool){
        label.text = labelText
        addSubview(label)
        switcher.scaleBy(0.75)
        switcher.isOn = isOn
        switcher.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
        addSubview(switcher)
        label.placeAfter(anchor: leadingAnchor)
        switcher.placeBefore(anchor: trailingAnchor)
    }
    
    func setEnabled(_ flag: Bool){
        switcher.isEnabled = flag
    }
    
    @objc func valueDidChange(sender:UISwitch){
        delegate?.switchValueDidChange(sender: self,isOn: sender.isOn)
    }
    
}
