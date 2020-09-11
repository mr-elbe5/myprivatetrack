//
//  MainTabController.swift
//
//  Created by Michael Rönnau on 14.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

enum TabTags{
    case timeline, map, settings, info
}

class MainTabController: UITabBarController {
    
    static var instance : MainTabController{
        get{
            return UIApplication.shared.windows.first!.rootViewController as! MainTabController
        }
    }
    
    override func loadView() {
        super.loadView()
        let timelineViewController = TimelineViewController()
        timelineViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("timeline", comment: ""), image: UIImage(systemName: "rectangle.stack"), tag: TabTags.timeline.hashValue)
        let mapViewController = MapViewController()
        mapViewController.tabBarItem = UITabBarItem(title: "map".localize(), image: UIImage(systemName: "globe"), tag: TabTags.map.hashValue)
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "settings".localize(), image: UIImage(systemName: "slider.horizontal.3"), tag: TabTags.settings.hashValue)
        let infoViewController = AppInfoViewController()
        infoViewController.tabBarItem = UITabBarItem(title: "info".localize(), image: UIImage(systemName: "info"), tag: TabTags.info.hashValue)
        
        let tabBarList = [timelineViewController, mapViewController, settingsViewController, infoViewController]
        viewControllers = tabBarList
        selectedViewController = timelineViewController
    }
    
    static func getViewController(tag: TabTags) -> UIViewController?{
        let viewController = instance
        for viewController in viewController.viewControllers!{
            if viewController.tabBarItem!.tag == tag.hashValue{
                return viewController
            }
        }
        return nil
    }
    
    static func getTimelineViewController() -> TimelineViewController?{
        return getViewController(tag: .timeline) as! TimelineViewController?
    }
    
    static func getMapViewController() -> MapViewController?{
        return getViewController(tag: .map) as! MapViewController?
    }
    
    static func getSettingsViewController() -> SettingsViewController?{
        return getViewController(tag: .settings) as! SettingsViewController?
    }
    
    static func getInfoViewController() -> InfoViewController?{
        return getViewController(tag: .info) as! InfoViewController?
    }

}


