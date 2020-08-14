//
//  UIViewController.swift
//  myprivatetrack
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
    
    var dataContainer : DataContainer {
        get{
            return DataStore.shared.data
        }
    }
    
    var settings : Settings {
        get{
            return DataStore.shared.settings
        }
    }
    
    func showAlert(title: String, text: String){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok".localize(),
                                                style: .cancel,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

