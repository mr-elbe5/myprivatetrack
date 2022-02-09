/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class MapInfoViewController: InfoViewController {
    
    let headerText = InfoHeader(text: "mapInfoHeader".localize())
    let topText = InfoText(text: "mapTopInfo".localize())
    
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(headerText)
        stackView.addArrangedSubview(topText)
    }
    
}
