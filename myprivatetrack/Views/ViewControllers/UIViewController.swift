//
//  UIViewController.swift
//  myprivatetrack
//
//  Created by Michael Rönnau on 15.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import UIKit

extension UIViewController{
    
    public var defaultInset : CGFloat{
        get{
            return ViewStatics.defaultInset
        }
    }
    
    public var defaultInsets : UIEdgeInsets{
        get{
            return ViewStatics.defaultInsets
        }
    }
    
    public var flatInsets : UIEdgeInsets{
        get{
            return ViewStatics.flatInsets
        }
    }
    
    public var narrowInsets : UIEdgeInsets{
        get{
            return ViewStatics.narrowInsets
        }
    }
    
    public func showAlert(title: String, text: String, onOk: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok",comment: ""),style: .default) { action in
            onOk?()
        })
        self.present(alertController, animated: true)
    }
    
    public func showApprove(title: String, text: String, onApprove: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("yes",comment: ""), style: .default) { action in
            onApprove?()
        })
        alertController.addAction(UIAlertAction(title: NSLocalizedString("no",comment: ""), style: .cancel))
        self.present(alertController, animated: true)
    }
    
}

