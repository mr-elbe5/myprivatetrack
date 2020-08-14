//
//  TableViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 07.08.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class TableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var headerView : UIView? = nil
    var tableView = UITableView()
    
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
        view.addSubview(tableView)
        tableView.enableAnchors()
        tableView.setLeadingAnchor(guide.leadingAnchor, padding: .zero)
        tableView.setTopAnchor(headerView?.bottomAnchor ?? guide.topAnchor, padding: 1)
        tableView.setTrailingAnchor(guide.trailingAnchor,padding: .zero)
        tableView.setBottomAnchor(guide.bottomAnchor, padding: .zero)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupHeaderView(){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
