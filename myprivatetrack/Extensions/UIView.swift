/*
 SwiftyMaps
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

import UIKit

extension UIView{
    
    var defaultInset : CGFloat{
        Insets.defaultInset
    }
    
    var defaultInsets : UIEdgeInsets{
        Insets.defaultInsets
    }
    
    var doubleInsets : UIEdgeInsets{
        Insets.doubleInsets
    }
    
    var flatInsets : UIEdgeInsets{
        Insets.flatInsets
    }
    
    var narrowInsets : UIEdgeInsets{
        Insets.narrowInsets
    }
    
    var highPriority : Float{
        900
    }
    
    var midPriority : Float{
        500
    }
    
    var lowPriority : Float{
        300
    }
    
    static var defaultPriority : Float{
        900
    }
    
    var transparentColor : UIColor{
        if isDarkMode{
            return UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
        }
        else{
            return UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.85)
        }
    }
    
    var isDarkMode: Bool {
        self.traitCollection.userInterfaceStyle == .dark
    }
    
    func setRoundedBorders(){
        layer.borderWidth = 0.5
        layer.cornerRadius = 5
    }
    
    func setGrayRoundedBorders(){
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 5
    }
    
    func scaleBy(_ factor: CGFloat){
        self.transform = CGAffineTransform(scaleX: factor, y:factor)
    }
    
    var firstResponder : UIView? {
        guard !isFirstResponder else {
            return self
        }
        for subview in subviews {
            if let view = subview.firstResponder {
                return view
            }
        }
        return nil
    }
    
    func resetConstraints(){
        for constraint in constraints{
            constraint.isActive = false
        }
    }
    
    func fillView(view: UIView, insets: UIEdgeInsets = .zero){
        setAnchors(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, insets: insets)
    }
    
    func fillSafeAreaOf(view: UIView, insets: UIEdgeInsets = .zero){
        setAnchors(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, insets: insets)
    }
    
    @discardableResult
    func setAnchors(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, insets: UIEdgeInsets = .zero) -> UIView{
        translatesAutoresizingMaskIntoConstraints = false
        return self.top(top, inset: insets.top)
            .leading(leading, inset: insets.left)
            .trailing(trailing, inset: -insets.right)
            .bottom(bottom, inset: -insets.bottom)
    }

    @discardableResult
    func setAnchors(centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil) -> UIView{
        translatesAutoresizingMaskIntoConstraints = false
        return self.centerX(centerX)
            .centerY(centerY)
    }
    
    @discardableResult
    func top(_ top: NSLayoutYAxisAnchor?, inset: CGFloat = 0) -> UIView{
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: inset).isActive = true
        }
        return self
    }
    
    @discardableResult
    func leading(_ leading: NSLayoutXAxisAnchor?, inset: CGFloat = 0) -> UIView{
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: inset).isActive = true
        }
        return self
    }
    
    @discardableResult
    func trailing(_ trailing: NSLayoutXAxisAnchor?, inset: CGFloat = 0) -> UIView{
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: inset).isActive = true
        }
        return self
    }
    
    @discardableResult
    func bottom(_ bottom: NSLayoutYAxisAnchor?, inset: CGFloat = 0) -> UIView{
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: inset).isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerX(_ centerX: NSLayoutXAxisAnchor?) -> UIView{
        if let centerX = centerX{
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerY(_ centerY: NSLayoutYAxisAnchor?) -> UIView{
        if let centerY = centerY{
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat, inset: CGFloat = 0) -> UIView{
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    func width(_ anchor: NSLayoutDimension, inset: CGFloat = 0) -> UIView{
        widthAnchor.constraint(equalTo: anchor, constant: inset) .isActive = true
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat) -> UIView{
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    func height(_ anchor: NSLayoutDimension, inset: CGFloat = 0) -> UIView{
        heightAnchor.constraint(equalTo: anchor, constant: inset) .isActive = true
        return self
    }
    
    @discardableResult
    func removeAllConstraints() -> UIView{
        for constraint in self.constraints{
            removeConstraint(constraint)
        }
        return self
    }
    
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func removeSubview(_ view : UIView) {
        for subview in subviews {
            if subview == view{
                subview.removeFromSuperview()
                break
            }
        }
    }

}

