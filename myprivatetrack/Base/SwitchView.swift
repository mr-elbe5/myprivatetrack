/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

protocol SwitchDelegate{
    func switchValueDidChange(sender: SwitchView,isOn: Bool)
}

class SwitchView : UIView{
    
    private var label = UILabel()
    private var switcher = UISwitch()
    
    var delegate : SwitchDelegate? = nil
    
    var isOn : Bool{
        switcher.isOn
    }
    
    func setupView(labelText: String, isOn : Bool){
        label.text = labelText
        addSubview(label)
        switcher.scaleBy(0.75)
        switcher.isOn = isOn
        switcher.addTarget(self, action: #selector(valueDidChange), for: .valueChanged)
        addSubview(switcher)
        label.setAnchors(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, insets: defaultInsets)
        switcher.setAnchors(top: topAnchor, trailing: trailingAnchor, bottom: bottomAnchor, insets: defaultInsets)
    }
    
    func setEnabled(_ flag: Bool){
        switcher.isEnabled = flag
    }
    
    @objc func valueDidChange(sender:UISwitch){
        delegate?.switchValueDidChange(sender: self,isOn: sender.isOn)
    }
    
}
