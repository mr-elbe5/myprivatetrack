//
//  FormViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 23.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class ScrollStackViewController: UIViewController {
    
    var scrollViewTopPadding : CGFloat = 1
    var headerView : UIView? = nil
    var scrollView = UIScrollView()
    var stackView = UIStackView()
    
    override func loadView() {
        super.loadView()
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
        scrollView.backgroundColor = .white
        scrollView.enableAnchors()
        scrollView.setLeadingAnchor(guide.leadingAnchor, padding: .zero)
        scrollView.setTopAnchor(headerView?.bottomAnchor ?? guide.topAnchor, padding: scrollViewTopPadding)
        scrollView.setTrailingAnchor(guide.trailingAnchor,padding: .zero)
        scrollView.setBottomAnchor(guide.bottomAnchor, padding: .zero)
        scrollView.setupVertical()
        scrollView.addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: .zero, left: .zero, bottom: Statics.defaultInset, right: .zero))
        stackView.setupVertical()
    }
    
    func setupHeaderView(){
        
    }
    
}

