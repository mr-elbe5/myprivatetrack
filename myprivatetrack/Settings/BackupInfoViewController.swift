/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

class BackupInfoViewController: InfoViewController {
    
    let backupHeader = InfoHeader(text: "backup".localize())
    let backupText = InfoText(text: "backupInfo".localize())
    
    override func loadView() {
        super.loadView()
        stackView.addArrangedSubview(backupHeader)
        stackView.addArrangedSubview(backupText)        
    }
    
    
}
