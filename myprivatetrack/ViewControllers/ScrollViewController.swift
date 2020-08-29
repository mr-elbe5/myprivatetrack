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
            headerView.enableAnchors()
            headerView.setLeadingAnchor(guide.leadingAnchor, padding: .zero)
            headerView.setTopAnchor(guide.topAnchor,padding: .zero)
            headerView.setTrailingAnchor(guide.trailingAnchor,padding: .zero)
        }
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = .systemBackground
        scrollView.enableAnchors()
        scrollView.setLeadingAnchor(guide.leadingAnchor, padding: .zero)
        scrollView.setTopAnchor(headerView?.bottomAnchor ?? guide.topAnchor, padding: scrollViewTopPadding)
        scrollView.setTrailingAnchor(guide.trailingAnchor,padding: .zero)
        scrollView.setBottomAnchor(guide.bottomAnchor, padding: .zero)
    }
    
    open func setupHeaderView(){
        
    }
    
}
