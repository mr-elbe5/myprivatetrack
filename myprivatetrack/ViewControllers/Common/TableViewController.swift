//
//  TableViewController.swift
//
//  Created by Michael Rönnau on 07.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

open class TableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    public var headerView : UIView? = nil
    public var tableView = UITableView()
    
    override open func loadView() {
        super.loadView()
        let guide = view.safeAreaLayoutGuide
        setupHeaderView()
        if let headerView = headerView{
            view.addSubview(headerView)
            headerView.setAnchors()
                .leading(guide.leadingAnchor, inset: .zero)
                .top(guide.topAnchor,inset: .zero)
                .trailing(guide.trailingAnchor,inset: .zero)
        }
        view.addSubview(tableView)
        tableView.setAnchors()
            .leading(guide.leadingAnchor, inset: .zero)
            .top(headerView?.bottomAnchor ?? guide.topAnchor, inset: 1)
            .trailing(guide.trailingAnchor,inset: .zero)
            .bottom(guide.bottomAnchor, inset: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    open func setupHeaderView(){
        
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
