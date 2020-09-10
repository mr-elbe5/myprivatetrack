//
//  ScrollViewController.swift
//
//  Created by Michael Rönnau on 18.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

open class ScrollViewController: UIViewController {
    
    public var scrollViewTopPadding : CGFloat = 1
    public var headerView : UIView? = nil
    public var scrollView = UIScrollView()
    
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
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = .systemBackground
        scrollView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(headerView?.bottomAnchor ?? guide.topAnchor, inset: scrollViewTopPadding)
            .trailing(guide.trailingAnchor,inset: .zero)
            .bottom(guide.bottomAnchor, inset: .zero)
    }
    
    open func setupHeaderView(){
        
    }
    
}
