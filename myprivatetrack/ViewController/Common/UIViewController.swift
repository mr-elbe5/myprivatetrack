//
//  UIViewController.swift
//
//  Created by Michael Rönnau on 15.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

extension UIViewController{
    
    public var defaultInset : CGFloat{
        get{
            return Statics.defaultInset
        }
    }
    
    public var defaultInsets : UIEdgeInsets{
        get{
            return Statics.defaultInsets
        }
    }
    
    public var flatInsets : UIEdgeInsets{
        get{
            return Statics.flatInsets
        }
    }
    
    public var narrowInsets : UIEdgeInsets{
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
    
    public func showAlert(title: String, text: String, onOk: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok".localize(),style: .default) { action in
            onOk?()
        })
        self.present(alertController, animated: true)
    }
    
    public func showApprove(title: String, text: String, onApprove: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "yes".localize(), style: .default) { action in
            onApprove?()
        })
        alertController.addAction(UIAlertAction(title: "no".localize(), style: .cancel))
        self.present(alertController, animated: true)
    }
    
}

