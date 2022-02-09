/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

import UIKit

extension UIScrollView{
    
    func setupVertical(){
        self.isScrollEnabled = true
        let scflg = self.contentLayoutGuide
        let svflg = self.frameLayoutGuide
        scflg.widthAnchor.constraint(equalTo: svflg.widthAnchor).isActive = true
    }
    
}

