/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import UIKit

extension UIViewController{
    
    var defaultInset : CGFloat{
        Insets.defaultInset
    }
    
    var defaultInsets : UIEdgeInsets{
        Insets.defaultInsets
    }
    
    var smallInset : CGFloat{
        Insets.smallInset
    }
    
    var smallInsets : UIEdgeInsets{
        Insets.smallInsets
    }
    
    var doubleInsets : UIEdgeInsets{
        Insets.doubleInsets
    }
    
    var flatInsets : UIEdgeInsets{
        Insets.flatInsets
    }
    
    var flatWideInsets : UIEdgeInsets{
        Insets.flatWideInsets
    }
    
    var narrowInsets : UIEdgeInsets{
        Insets.narrowInsets
    }
    
    var wideInsets : UIEdgeInsets{
        Insets.wideInsets
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
    
    func showDestructiveApprove(title: String, text: String, onApprove: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "yes".localize(), style: .destructive) { action in
            onApprove?()
        })
        alertController.addAction(UIAlertAction(title: "no".localize(), style: .cancel))
        self.present(alertController, animated: true)
    }
    
    func showApprove(title: String, text: String, onApprove: (() -> Void)? = nil){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "yes".localize(), style: .default) { action in
            onApprove?()
        })
        alertController.addAction(UIAlertAction(title: "no".localize(), style: .cancel))
        self.present(alertController, animated: true)
    }
    
    func showDone(title: String, text: String){
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok".localize(), style: .default))
        self.present(alertController, animated: true)
    }
    
}

