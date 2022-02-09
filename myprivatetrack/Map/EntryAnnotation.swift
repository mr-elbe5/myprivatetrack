/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit
import MapKit

class EntryAnnotation : MKPointAnnotation{
    
    var entry : EntryData
    
    init(entry: EntryData){
        self.entry = entry
    }
}
