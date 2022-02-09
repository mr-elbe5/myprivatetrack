/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

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


