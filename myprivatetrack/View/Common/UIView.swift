//
//  UIView.swift
//
//  Created by Michael Rönnau on 21.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
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
    
    var doubleInsets : UIEdgeInsets{
        get{
            return Statics.doubleInsets
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
    
    var highPriority : Float{
        get{
            return 900
        }
    }
    
    var midPriority : Float{
        get{
            return 500
        }
    }
    
    var lowPriority : Float{
        get{
            return 300
        }
    }
    
    static var defaultPriority : Float{
        get{
            return 900
        }
    }
    
    var transparentColor : UIColor{
        get{
            if isDarkMode{
                return UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
            }
            else{
                return UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.85)
            }
        }
    }
    
    var isDarkMode: Bool {
        return self.traitCollection.userInterfaceStyle == .dark
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
    
    func fillSuperview(insets: UIEdgeInsets = .zero){
        if let sv = superview{
            fillView(view: sv, insets: insets)
        }
    }
    
    func fillView(view: UIView, insets: UIEdgeInsets = .zero){
        setAnchors()
            .leading(view.leadingAnchor,inset: insets.left)
            .top(view.topAnchor,inset: insets.top)
            .trailing(view.trailingAnchor,inset: insets.right)
            .bottom(view.bottomAnchor,inset: insets.bottom)
    }
    
    func fillSafeAreaOf(view: UIView, insets: UIEdgeInsets = .zero){
        setAnchors()
            .leading(view.safeAreaLayoutGuide.leadingAnchor,inset: insets.left)
            .top(view.safeAreaLayoutGuide.topAnchor,inset: insets.top)
            .trailing(view.safeAreaLayoutGuide.trailingAnchor,inset: insets.right)
            .bottom(view.safeAreaLayoutGuide.bottomAnchor,inset: insets.bottom)
    }
    
    func setCentral(view: UIView){
        setAnchors()
            .centerX(view.centerXAnchor)
            .centerY(view.centerYAnchor)
    }
    
    func placeBelow(anchor: NSLayoutYAxisAnchor, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .top(anchor,inset: insets.top, priority : priority)
            .leading(superview?.leadingAnchor,inset: insets.left, priority : priority)
            .trailing(superview?.trailingAnchor, inset: insets.right, priority : priority)
    }
    
    func placeBelow(view: UIView, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeBelow(anchor: view.bottomAnchor, insets: insets, priority : priority)
    }
    
    func placeAbove(anchor: NSLayoutYAxisAnchor, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .bottom(anchor,inset: insets.top, priority : priority)
            .leading(superview?.leadingAnchor,inset: insets.left, priority : priority)
            .trailing(superview?.trailingAnchor, inset: insets.right, priority : priority)
    }
    
    func placeAbove(view: UIView, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeAbove(anchor: view.topAnchor, insets: insets, priority : priority)
    }
    
    func connectBottom(view: UIView, insets: CGFloat = Statics.defaultInset,priority: Float = defaultPriority){
        bottom(view.bottomAnchor, inset: insets, priority : priority)
    }
    
    func placeBefore(anchor: NSLayoutXAxisAnchor, insets: UIEdgeInsets = Statics.defaultInsets, priority: Float = defaultPriority){
        setAnchors()
            .trailing(anchor, inset: insets.right, priority : priority)
            .top(superview?.topAnchor, inset: insets.top, priority : priority)
            .bottom(superview?.bottomAnchor, inset: insets.bottom, priority: priority)
    }
    
    func placeBefore(view: UIView, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeBefore(anchor: view.leadingAnchor, insets: insets, priority: priority)
    }
    
    func placeAfter(anchor: NSLayoutXAxisAnchor, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .leading(anchor,inset: insets.left, priority: priority)
            .top(superview?.topAnchor,inset: insets.top, priority: priority)
            .bottom(superview?.bottomAnchor, inset: insets.bottom, priority: priority)
    }
    
    func placeAfter(view: UIView, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeAfter(anchor: view.trailingAnchor, insets: insets, priority : priority)
    }
    
    func placeXCentered(insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .centerX(superview?.centerXAnchor,priority: priority)
            .top(superview?.topAnchor,inset: insets.top, priority: priority)
            .bottom(superview?.bottomAnchor, inset: insets.bottom, priority: priority)
    }
    
    func placeTopRight(insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .top(superview?.topAnchor, inset: insets.top, priority: priority)
            .trailing(superview?.trailingAnchor, inset: insets.right, priority: priority)
    }
    
    @discardableResult
    func setAnchors() -> UIView{
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    func leading(_ anchor: NSLayoutXAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
        if let anchor = anchor{
            let constraint = leadingAnchor.constraint(equalTo: anchor, constant: inset)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func trailing(_ anchor: NSLayoutXAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
        if let anchor = anchor{
            let constraint = trailingAnchor.constraint(equalTo: anchor, constant: -inset)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func top(_ anchor: NSLayoutYAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
        if let anchor = anchor{
            let constraint = topAnchor.constraint(equalTo: anchor, constant: inset)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func bottom(_ anchor: NSLayoutYAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
        if let anchor = anchor{
            let constraint = bottomAnchor.constraint(equalTo: anchor, constant: -inset)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerX(_ anchor: NSLayoutXAxisAnchor?,priority: Float = defaultPriority) -> UIView{
        if anchor != nil{
            let constraint = centerXAnchor.constraint(equalTo: anchor!)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func centerY(_ anchor: NSLayoutYAxisAnchor?,priority: Float = defaultPriority) -> UIView{
        if anchor != nil{
            let constraint = centerYAnchor.constraint(equalTo: anchor!)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
        return self
    }
    
    @discardableResult
    func width(_ width: CGFloat, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    func width(_ anchor: NSLayoutDimension, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
        widthAnchor.constraint(equalTo: anchor, constant: inset) .isActive = true
        return self
    }
    
    @discardableResult
    func height(_ height: CGFloat,priority: Float = defaultPriority) -> UIView{
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    func height(_ anchor: NSLayoutDimension, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
        heightAnchor.constraint(equalTo: anchor, constant: inset) .isActive = true
        return self
    }
    
    @discardableResult
    func setSquareByWidth(priority: Float = defaultPriority) -> UIView{
        let c = NSLayoutConstraint(item: self, attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .height,
                                   multiplier: 1, constant: 0)
        c.priority = UILayoutPriority(priority)
        self.addConstraint(c)
        return self
    }
    
    @discardableResult
    func setSquareByHeight(priority: Float = defaultPriority) -> UIView{
        let c = NSLayoutConstraint(item: self, attribute: .height,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .width,
                                   multiplier: 1, constant: 0)
        c.priority = UILayoutPriority(priority)
        self.addConstraint(c)
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
