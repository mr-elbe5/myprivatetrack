//
//  SwitchIconButton.swift
//
//  Created by Michael Rönnau on 11.08.21.
//  Copyright © 2021 Michael Rönnau. All rights reserved.
//


import UIKit

protocol SwitchIconDelegate{
    func switchValueDidChange(icon: SwitchIcon)
}

class SwitchIcon : UIButton{
    
    var isOn : Bool
    
    var onImage : UIImage
    var offImage : UIImage
    
    var onColor : UIColor!
    var offColor : UIColor!
    
    var delegate : SwitchIconDelegate? = nil
    
    init(offImage: UIImage, onImage: UIImage, isOn : Bool  = false){
        self.offImage = offImage
        self.onImage = onImage
        self.isOn = isOn
        super.init(frame: .zero)
        onColor = tintColor
        offColor = tintColor
        setImage(isOn ? onImage : offImage, for: .normal)
        self.scaleBy(1.25)
        self.addTarget(self, action: #selector(switchDidChange), for: .touchDown)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOn(_ isOn : Bool){
        self.isOn = isOn
        setIconAndColor()
    }
    
    @objc func switchDidChange(){
        isOn = !isOn
        setIconAndColor()
        delegate?.switchValueDidChange(icon: self)
    }
    
    func setIconAndColor(){
        if isOn{
            setImage(onImage, for: .normal)
            tintColor = onColor
            setTitleColor(onColor, for: .normal)
        }
        else{
            setImage(offImage, for: .normal)
            tintColor = offColor
            setTitleColor(offColor, for: .normal)
        }
    }
    
}

