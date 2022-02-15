/*
 My Private Track
 App for creating a diary with entry based on time and map location using text, photos, audios and videos
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
            return UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        }
        else{
            return UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 0.6)
        }
    }
    
    var isDarkMode: Bool {
        self.traitCollection.userInterfaceStyle == .dark
    }
    
    func setRoundedBorders(radius: CGFloat = 5){
        layer.borderWidth = 0.5
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func setGrayRoundedBorders(radius: CGFloat = 5){
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func getExtendedIntrinsicContentSize(originalSize: CGSize) -> CGSize{
        let height = originalSize.height + 6
        layer.cornerRadius = height/2
        layer.masksToBounds = true
        return CGSize(width: originalSize.width + 16, height: height)
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
    func top(_ top: NSLayoutYAxisAnchor?, inset: CGFloat = 0, priority: Float = defaultPriority) -> UIView{
        if let top = top{
            let constraint = topAnchor.constraint(equalTo: top, constant: inset)
            if priority != UIView.defaultPriority{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func leading(_ leading: NSLayoutXAxisAnchor?, inset: CGFloat = 0, priority: Float = defaultPriority) -> UIView{
        if let leading = leading{
            let constraint = leadingAnchor.constraint(equalTo: leading, constant: inset)
            if priority != UIView.defaultPriority{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func trailing(_ trailing: NSLayoutXAxisAnchor?, inset: CGFloat = 0, priority: Float = defaultPriority) -> UIView{
        if let trailing = trailing{
            let constraint = trailingAnchor.constraint(equalTo: trailing, constant: inset)
            if priority != UIView.defaultPriority{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func bottom(_ bottom: NSLayoutYAxisAnchor?, inset: CGFloat = 0, priority: Float = defaultPriority) -> UIView{
        if let bottom = bottom{
            let constraint = bottomAnchor.constraint(equalTo: bottom, constant: inset)
            if priority != UIView.defaultPriority{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerX(_ centerX: NSLayoutXAxisAnchor?, priority: Float = defaultPriority) -> UIView{
        if let centerX = centerX{
            let constraint = centerXAnchor.constraint(equalTo: centerX)
            if priority != UIView.defaultPriority{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerY(_ centerY: NSLayoutYAxisAnchor?, priority: Float = defaultPriority) -> UIView{
        if let centerY = centerY{
            let constraint = centerYAnchor.constraint(equalTo: centerY)
            if priority != UIView.defaultPriority{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat, inset: CGFloat = 0, priority: Float = defaultPriority) -> UIView{
        let constraint = widthAnchor.constraint(equalToConstant: width)
        if priority != UIView.defaultPriority{
            constraint.priority = UILayoutPriority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func width(_ anchor: NSLayoutDimension, inset: CGFloat = 0, priority: Float = defaultPriority) -> UIView{
        let constraint = widthAnchor.constraint(equalTo: anchor, constant: inset)
        if priority != UIView.defaultPriority{
            constraint.priority = UILayoutPriority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func width(_ anchor: NSLayoutDimension, percentage: CGFloat, inset: CGFloat = 0, priority: Float = defaultPriority) -> UIView{
        let constraint = widthAnchor.constraint(equalTo: anchor, multiplier: percentage, constant: inset)
        if priority != UIView.defaultPriority{
            constraint.priority = UILayoutPriority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat, priority: Float = defaultPriority) -> UIView{
        let constraint = heightAnchor.constraint(equalToConstant: height)
        if priority != UIView.defaultPriority{
            constraint.priority = UILayoutPriority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func height(_ anchor: NSLayoutDimension, inset: CGFloat = 0, priority: Float = defaultPriority) -> UIView{
        let constraint = heightAnchor.constraint(equalTo: anchor, constant: inset)
        if priority != UIView.defaultPriority{
            constraint.priority = UILayoutPriority(priority)
        }
        constraint.isActive = true
        return self
    }
    
    @discardableResult
    func height(_ anchor: NSLayoutDimension, percentage: CGFloat, inset: CGFloat = 0, priority: Float = defaultPriority) -> UIView{
        let constraint = heightAnchor.constraint(equalTo: anchor, multiplier: percentage, constant: inset)
        if priority != UIView.defaultPriority{
            constraint.priority = UILayoutPriority(priority)
        }
        constraint.isActive = true
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

