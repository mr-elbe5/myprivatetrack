/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class RestoreInfoViewController: InfoViewController {
    
    let restoreHeader = InfoHeader(text: "restore".localize())
    let restoreText = InfoText(text: "restoreInfo".localize())
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(restoreHeader)
        stackView.addArrangedSubview(restoreText)
    }
    
    
}
