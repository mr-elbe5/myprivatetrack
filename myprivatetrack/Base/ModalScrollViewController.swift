/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

open class ModalScrollViewController: ScrollViewController {
    
    var headerView = UIView()
    
    var closeButton = IconButton(icon: "xmark.circle")
    
    override open func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        let guide = view.safeAreaLayoutGuide
        setupHeaderView()
        view.addSubview(headerView)
        headerView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: .zero)
        setupScrollView()
        scrollView.setAnchors(leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: .zero)
            .top(headerView.bottomAnchor, inset: 0)
    }
    
    func setupHeaderView(){
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
        closeButton.setAnchors(top: headerView.topAnchor, trailing: headerView.trailingAnchor, bottom: headerView.bottomAnchor, insets: defaultInsets)
            .iconHeight()
    }
    
    override func setupScrollView(){
        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
    }
    
    @objc func close(){
        self.dismiss(animated: true, completion: {
        })
    }
    
}
