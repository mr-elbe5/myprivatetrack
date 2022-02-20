/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import UIKit

open class ScrollViewController: UIViewController {
    
    var scrollView = UIScrollView()
    
    func setupScrollView(){
        scrollView.backgroundColor = .systemBackground
        scrollView.setupVertical()
        view.addSubview(scrollView)
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name:UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardDidShow(notification:NSNotification){
        if let firstResponder = scrollView.firstResponder{
            let rect : CGRect = firstResponder.frame
            var parentView = firstResponder.superview
            var offset : CGFloat = 0
            while parentView != nil && parentView != scrollView {
                offset += parentView!.frame.minY
                parentView = parentView!.superview
            }
            scrollView.scrollRectToVisible(.init(x: rect.minX, y: rect.minY + offset, width: rect.width, height: rect.height), animated: true)
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
}
