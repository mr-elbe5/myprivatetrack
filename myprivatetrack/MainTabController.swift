//
//  MainTabController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 14.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

enum TabTags{
    case events, map/*, settings*/
}

class MainTabController: UITabBarController {
    
    override func loadView() {
        super.loadView()
        let timelineViewController = TimelineViewController()
        timelineViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("timeline", comment: ""), image: UIImage(systemName: "rectangle.stack"), tag: TabTags.events.hashValue)
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("map", comment: ""), image: UIImage(systemName: "globe"), tag: TabTags.map.hashValue)
//        let settingsViewController = SettingsViewController()
//        settingsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("settings", comment: ""), image: UIImage(systemName: "slider.horizontal.3"), tag: TabTags.settings.hashValue)
        
        let tabBarList = [timelineViewController, mapViewController/*, settingsViewController*/]
        viewControllers = tabBarList
        selectedViewController = timelineViewController
    }

}


