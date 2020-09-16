//
//  UIViewController.swift
//
//  Created by Michael Rönnau on 15.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

extension UIViewController{
    
    var defaultInset : CGFloat{
        get{
            return Statics.defaultInset
        }
    }
    
    var defaultInsets : UIEdgeInsets{
        get{
            return Statics.defaultInsets
        }
    }
    
    var flatInsets : UIEdgeInsets{
        get{
            return Statics.flatInsets
        }
    }
    
    var narrowInsets : UIEdgeInsets{
        get{
            return Statics.narrowInsets
        }
    }
    
    var globalData : GlobalData {
        get{
            return GlobalData.shared
        }
    }
    
    var settings : Settings {
        get{
            return Settings.shared
        }
    }
    
    var isDarkMode: Bool {
        return self.traitCollection.userInterfaceStyle == .dark
    }
    
    func showAlert(title: String, text: String, onOk: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok".localize(),style: .default) { action in
            onOk?()
        })
        self.present(alertController, animated: true)
    }
    
    func showApprove(title: String, text: String, onApprove: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "yes".localize(), style: .destructive) { action in
            onApprove?()
        })
        alertController.addAction(UIAlertAction(title: "no".localize(), style: .cancel))
        self.present(alertController, animated: true)
    }
    
}

