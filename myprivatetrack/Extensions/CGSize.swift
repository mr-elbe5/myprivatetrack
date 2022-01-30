/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */
import Foundation
import UIKit

extension CGSize{
    
    func scaleBy(_ scale: CGFloat) -> CGSize{
        CGSize(width: width*scale, height: height*scale)
    }
    
}

