/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

open class ModalViewController: ViewController {
    
    var stackView = UIStackView()
    
    override open func loadView() {
        self.mainViewTopPadding = 0
        super.loadView()
    }
    
    override open func setupHeaderView(){
        let buttonView = UIView()
        buttonView.backgroundColor = UIColor.systemBackground
        let closeButton = IconButton(icon: "xmark.circle")
        buttonView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        closeButton.setAnchors(top: buttonView.topAnchor, trailing: buttonView.trailingAnchor, bottom: buttonView.bottomAnchor, insets: defaultInsets)
            .iconHeight()
        headerView = buttonView
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: {
        })
    }
    
}
