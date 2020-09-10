//
//  ViewController.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

open class ViewController: UIViewController {
    
    public var mainViewTopPadding : CGFloat = 1
    public var headerView : UIView? = nil
    public var mainView = UIView()
    
    override open func loadView() {
        super.loadView()
        view.backgroundColor = .systemGroupedBackground
        let guide = view.safeAreaLayoutGuide
        setupHeaderView()
        if let headerView = headerView{
            view.addSubview(headerView)
            headerView.setAnchors()
                .leading(guide.leadingAnchor, inset: .zero)
                .top(guide.topAnchor,inset: .zero)
                .trailing(guide.trailingAnchor,inset: .zero)
        }
        self.view.addSubview(mainView)
        mainView.backgroundColor = .systemBackground
        mainView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(headerView?.bottomAnchor ?? guide.topAnchor, inset: mainViewTopPadding)
            .trailing(guide.trailingAnchor,inset: .zero)
            .bottom(guide.bottomAnchor, inset: .zero)
    }
    
    open func setupHeaderView(){
        
    }
    
}
