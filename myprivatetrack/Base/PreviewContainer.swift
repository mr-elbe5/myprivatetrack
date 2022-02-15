/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

class PreviewContainer: UIView{
    
    var previews = Array<UIView>()
    
    func setupPreviews(){
        let cols = Int(floor(sqrt(Double(previews.count - 1)))) + 1
        let rows = (previews.count - 1)/cols + 1
        let percentage = 1.0 / Double(cols)
        var itemTopAnchor = topAnchor
        var itemLeadingAnchor = leadingAnchor
        for idx in 0..<previews.count{
            let col = idx % cols
            let row = idx/cols
            let preview = previews[idx]
            addSubview(preview)
            preview.setAnchors(top: itemTopAnchor, leading: itemLeadingAnchor)
                .width(widthAnchor, percentage: percentage)
                .height(widthAnchor, percentage: percentage)
            if col == cols - 1{
                itemTopAnchor = preview.bottomAnchor
                itemLeadingAnchor = leadingAnchor
            }
            else{
                itemLeadingAnchor = preview.trailingAnchor
            }
            if row == rows - 1{
                preview.bottom(bottomAnchor, priority: lowPriority)
            }
        }
        
    }
    
}
