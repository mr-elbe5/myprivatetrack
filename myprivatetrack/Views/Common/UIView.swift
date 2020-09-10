//
//  UIView.swift
//
//  Created by Michael Rönnau on 21.06.20.
//  Copyright © 2020 Michael Rönnau. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
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
    
    public var doubleInsets : UIEdgeInsets{
        get{
            return Statics.doubleInsets
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
    
    public var highPriority : Float{
        get{
            return 900
        }
    }
    
    public var midPriority : Float{
        get{
            return 500
        }
    }
    
    public var lowPriority : Float{
        get{
            return 300
        }
    }
    
    public static var defaultPriority : Float{
        get{
            return 900
        }
    }
    
    public func setRoundedBorders(){
        layer.borderWidth = 0.5
        layer.cornerRadius = 5
    }
    
    public func setGrayRoundedBorders(){
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 5
    }
    
    public func scaleBy(_ factor: CGFloat){
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
    
    public func resetConstraints(){
        for constraint in constraints{
            constraint.isActive = false
        }
    }
    
    public func fillSuperview(insets: UIEdgeInsets = .zero){
        if let sv = superview{
            fillView(view: sv, insets: insets)
        }
    }
    
    public func fillView(view: UIView, insets: UIEdgeInsets = .zero){
        setAnchors()
            .leading(view.leadingAnchor,inset: insets.left)
            .top(view.topAnchor,inset: insets.top)
            .trailing(view.trailingAnchor,inset: insets.right)
            .bottom(view.bottomAnchor,inset: insets.bottom)
    }
    
    public func fillSafeAreaOf(view: UIView, insets: UIEdgeInsets = .zero){
        setAnchors()
            .leading(view.safeAreaLayoutGuide.leadingAnchor,inset: insets.left)
            .top(view.safeAreaLayoutGuide.topAnchor,inset: insets.top)
            .trailing(view.safeAreaLayoutGuide.trailingAnchor,inset: insets.right)
            .bottom(view.safeAreaLayoutGuide.bottomAnchor,inset: insets.bottom)
    }
    
    public func setCentral(view: UIView){
        setAnchors()
            .centerX(view.centerXAnchor)
            .centerY(view.centerYAnchor)
    }
    
    public func placeBelow(anchor: NSLayoutYAxisAnchor, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .top(anchor,inset: insets.top, priority : priority)
            .leading(superview?.leadingAnchor,inset: insets.left, priority : priority)
            .trailing(superview?.trailingAnchor, inset: insets.right, priority : priority)
    }
    
    public func placeBelow(view: UIView, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeBelow(anchor: view.bottomAnchor, insets: insets, priority : priority)
    }
    
    public func placeAbove(anchor: NSLayoutYAxisAnchor, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .bottom(anchor,inset: insets.top, priority : priority)
            .leading(superview?.leadingAnchor,inset: insets.left, priority : priority)
            .trailing(superview?.trailingAnchor, inset: insets.right, priority : priority)
    }
    
    public func placeAbove(view: UIView, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeAbove(anchor: view.topAnchor, insets: insets, priority : priority)
    }
    
    public func connectBottom(view: UIView, insets: CGFloat = Statics.defaultInset,priority: Float = defaultPriority){
        bottom(view.bottomAnchor, inset: insets, priority : priority)
    }
    
    public func placeBefore(anchor: NSLayoutXAxisAnchor, insets: UIEdgeInsets = Statics.defaultInsets, priority: Float = defaultPriority){
        setAnchors()
            .trailing(anchor, inset: insets.right, priority : priority)
            .top(superview?.topAnchor, inset: insets.top, priority : priority)
            .bottom(superview?.bottomAnchor, inset: insets.bottom, priority: priority)
    }
    
    public func placeBefore(view: UIView, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeBefore(anchor: view.leadingAnchor, insets: insets, priority: priority)
    }
    
    public func placeAfter(anchor: NSLayoutXAxisAnchor, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .leading(anchor,inset: insets.left, priority: priority)
            .top(superview?.topAnchor,inset: insets.top, priority: priority)
            .bottom(superview?.bottomAnchor, inset: insets.bottom, priority: priority)
    }
    
    public func placeAfter(view: UIView, insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeAfter(anchor: view.trailingAnchor, insets: insets, priority : priority)
    }
    
    public func placeXCentered(insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .centerX(superview?.centerXAnchor,priority: priority)
            .top(superview?.topAnchor,inset: insets.top, priority: priority)
            .bottom(superview?.bottomAnchor, inset: insets.bottom, priority: priority)
    }
    
    public func placeTopRight(insets: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        setAnchors()
            .top(superview?.topAnchor, inset: insets.top, priority: priority)
            .trailing(superview?.trailingAnchor, inset: insets.right, priority: priority)
    }
    
    @discardableResult
    public func setAnchors() -> UIView{
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    @discardableResult
    public func leading(_ anchor: NSLayoutXAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
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
    public func trailing(_ anchor: NSLayoutXAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
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
    public func top(_ anchor: NSLayoutYAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
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
    public func bottom(_ anchor: NSLayoutYAxisAnchor?, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
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
    public func centerX(_ anchor: NSLayoutXAxisAnchor?,priority: Float = defaultPriority) -> UIView{
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
    public func centerY(_ anchor: NSLayoutYAxisAnchor?,priority: Float = defaultPriority) -> UIView{
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
    public func width(_ width: CGFloat, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    @discardableResult
    public func width(_ anchor: NSLayoutDimension, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
        widthAnchor.constraint(equalTo: anchor, constant: inset) .isActive = true
        return self
    }
    
    @discardableResult
    public func height(_ height: CGFloat,priority: Float = defaultPriority) -> UIView{
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult
    public func height(_ anchor: NSLayoutDimension, inset: CGFloat = 0,priority: Float = defaultPriority) -> UIView{
        heightAnchor.constraint(equalTo: anchor, constant: inset) .isActive = true
        return self
    }
    
    @discardableResult
    public func setSquareByWidth(priority: Float = defaultPriority) -> UIView{
        let c = NSLayoutConstraint(item: self, attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .height,
                                   multiplier: 1, constant: 0)
        c.priority = UILayoutPriority(priority)
        self.addConstraint(c)
        return self
    }
    
    @discardableResult
    public func setSquareByHeight(priority: Float = defaultPriority) -> UIView{
        let c = NSLayoutConstraint(item: self, attribute: .height,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .width,
                                   multiplier: 1, constant: 0)
        c.priority = UILayoutPriority(priority)
        self.addConstraint(c)
        return self
    }
    
    @discardableResult
    public func removeAllConstraints() -> UIView{
        for constraint in self.constraints{
            removeConstraint(constraint)
        }
        return self
    }
    
    public func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    public func removeSubview(_ view : UIView) {
        for subview in subviews {
            if subview == view{
                subview.removeFromSuperview()
                break
            }
        }
    }

}
