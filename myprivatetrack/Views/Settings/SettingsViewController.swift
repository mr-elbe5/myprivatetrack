//
//  SettingsViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 13.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: EditViewController, SwitchDelegate{

    var useLocationSwitch = SwitchView()
    
    override func loadView() {
        super.loadView()
        
        let header = InfoHeader(text: "settings".localize())
        stackView.addArrangedSubview(header)
        useLocationSwitch.setupView(text: "useLocation".localize(), isOn: settings.useLocation)
        useLocationSwitch.delegate = self
        stackView.addArrangedSubview(useLocationSwitch)
    }
    
    override func setupHeaderView(){
        let headerView = UIView()
        let rightStackView = UIStackView()
        headerView.backgroundColor = UIColor.systemBackground
        headerView.addSubview(rightStackView)
        rightStackView.setupHorizontal(spacing: defaultInset)
        rightStackView.placeBefore(anchor: headerView.trailingAnchor, padding: defaultInsets)
        
        let infoButton = IconButton(icon: "info.circle")
        infoButton.addTarget(self, action: #selector(showInfo), for: .touchDown)
        rightStackView.addArrangedSubview(infoButton)
        
        self.headerView = headerView
    }
    
    @objc func showInfo(){
        let infoController = SettingsInfoViewController()
        self.present(infoController, animated: true)
    }
    
    func switchValueDidChange(sender: SwitchView, isOn: Bool) {
        if sender == useLocationSwitch{
            settings.useLocation = isOn
            if settings.useLocation{
                LocationService.shared.startUpdatingLocation()
            }
            else{
                LocationService.shared.stopUpdatingLocation()
            }
            
        }
        settings.save()
    }


}
