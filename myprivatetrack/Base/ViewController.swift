/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

open class ViewController: UIViewController {
    
    var mainViewTopPadding : CGFloat = 1
    var headerView : UIView? = nil
    var mainView = UIView()
    
    override open func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        let guide = view.safeAreaLayoutGuide
        setupHeaderView()
        if let headerView = headerView{
            view.addSubview(headerView)
            headerView.setAnchors(top: guide.topAnchor, leading: guide.leadingAnchor, trailing: guide.trailingAnchor, insets: .zero)
        }
        self.view.addSubview(mainView)
        mainView.backgroundColor = .systemBackground
        mainView.setAnchors(leading: guide.leadingAnchor, trailing: guide.trailingAnchor, bottom: guide.bottomAnchor, insets: .zero)
            .top(headerView?.bottomAnchor ?? guide.topAnchor, inset: mainViewTopPadding)
    }
    
    open func setupHeaderView(){
        
    }
    
}
