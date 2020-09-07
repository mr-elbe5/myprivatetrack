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
    
    public func fillSuperview(padding: UIEdgeInsets = .zero){
        if let sv = superview{
            fillView(view: sv, padding: padding)
        }
    }
    
    public func fillView(view: UIView, padding: UIEdgeInsets = .zero){
        enableAnchors()
        setLeadingAnchor(view.leadingAnchor,padding: padding.left)
        setTopAnchor(view.topAnchor,padding: padding.top)
        setTrailingAnchor(view.trailingAnchor,padding: padding.right)
        setBottomAnchor(view.bottomAnchor,padding: padding.bottom)
    }
    
    public func fillSafeAreaOf(view: UIView, padding: UIEdgeInsets = .zero){
        enableAnchors()
        setLeadingAnchor(view.safeAreaLayoutGuide.leadingAnchor,padding: padding.left)
        setTopAnchor(view.safeAreaLayoutGuide.topAnchor,padding: padding.top)
        setTrailingAnchor(view.safeAreaLayoutGuide.trailingAnchor,padding: padding.right)
        setBottomAnchor(view.safeAreaLayoutGuide.bottomAnchor,padding: padding.bottom)
    }
    
    public func setCentral(view: UIView){
        enableAnchors()
        setCenterXAnchor(view.centerXAnchor)
        setCenterYAnchor(view.centerYAnchor)
    }
    
    public func placeBelow(anchor: NSLayoutYAxisAnchor, padding: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        enableAnchors()
        setTopAnchor(anchor,padding: padding.top, priority : priority)
        setLeadingAnchor(superview?.leadingAnchor,padding: padding.left, priority : priority)
        setTrailingAnchor(superview?.trailingAnchor, padding: padding.right, priority : priority)
    }
    
    public func placeBelow(view: UIView, padding: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeBelow(anchor: view.bottomAnchor, padding: padding, priority : priority)
    }
    
    public func placeAbove(anchor: NSLayoutYAxisAnchor, padding: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        enableAnchors()
        setBottomAnchor(anchor,padding: padding.top, priority : priority)
        setLeadingAnchor(superview?.leadingAnchor,padding: padding.left, priority : priority)
        setTrailingAnchor(superview?.trailingAnchor, padding: padding.right, priority : priority)
    }
    
    public func placeAbove(view: UIView, padding: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeAbove(anchor: view.topAnchor, padding: padding, priority : priority)
    }
    
    public func connectBottom(view: UIView, padding: CGFloat = Statics.defaultInset,priority: Float = defaultPriority){
        setBottomAnchor(view.bottomAnchor, padding: padding, priority : priority)
    }
    
    public func placeBefore(anchor: NSLayoutXAxisAnchor, padding: UIEdgeInsets = Statics.defaultInsets, priority: Float = defaultPriority){
        enableAnchors()
        setTrailingAnchor(anchor, padding: padding.right, priority : priority)
        setTopAnchor(superview?.topAnchor, padding: padding.top, priority : priority)
        setBottomAnchor(superview?.bottomAnchor, padding: padding.bottom, priority: priority)
    }
    
    public func placeBefore(view: UIView, padding: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeBefore(anchor: view.leadingAnchor, padding: padding, priority: priority)
    }
    
    public func placeAfter(anchor: NSLayoutXAxisAnchor, padding: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        enableAnchors()
        setLeadingAnchor(anchor,padding: padding.left, priority: priority)
        setTopAnchor(superview?.topAnchor,padding: padding.top, priority: priority)
        setBottomAnchor(superview?.bottomAnchor, padding: padding.bottom, priority: priority)
    }
    
    public func placeAfter(view: UIView, padding: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        placeAfter(anchor: view.trailingAnchor, padding: padding, priority : priority)
    }
    
    public func placeXCentered(padding: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        enableAnchors()
        setCenterXAnchor(superview?.centerXAnchor,priority: priority)
        setTopAnchor(superview?.topAnchor,padding: padding.top, priority: priority)
        setBottomAnchor(superview?.bottomAnchor, padding: padding.bottom, priority: priority)
    }
    
    public func placeTopRight(padding: UIEdgeInsets = Statics.defaultInsets,priority: Float = defaultPriority){
        enableAnchors()
        setTopAnchor(superview?.topAnchor, padding: padding.top, priority: priority)
        setTrailingAnchor(superview?.trailingAnchor, padding: padding.right, priority: priority)
    }
    
    public func enableAnchors(){
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func setLeadingAnchor(_ anchor: NSLayoutXAxisAnchor?, padding: CGFloat = 0,priority: Float = defaultPriority){
        if let anchor = anchor{
            let constraint = leadingAnchor.constraint(equalTo: anchor, constant: padding)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
    }
    
    public func setTrailingAnchor(_ anchor: NSLayoutXAxisAnchor?, padding: CGFloat = 0,priority: Float = defaultPriority){
        if let anchor = anchor{
            let constraint = trailingAnchor.constraint(equalTo: anchor, constant: -padding)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
    }
    
    public func setTopAnchor(_ anchor: NSLayoutYAxisAnchor?, padding: CGFloat = 0,priority: Float = defaultPriority){
        if let anchor = anchor{
            let constraint = topAnchor.constraint(equalTo: anchor, constant: padding)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
    }
    
    public func setBottomAnchor(_ anchor: NSLayoutYAxisAnchor?, padding: CGFloat = 0,priority: Float = defaultPriority){
        if let anchor = anchor{
            let constraint = bottomAnchor.constraint(equalTo: anchor, constant: -padding)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
    }
    
    public func setCenterXAnchor(_ anchor: NSLayoutXAxisAnchor?,priority: Float = defaultPriority){
        if anchor != nil{
            let constraint = centerXAnchor.constraint(equalTo: anchor!)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
    }
    
    public func setCenterYAnchor(_ anchor: NSLayoutYAxisAnchor?,priority: Float = defaultPriority ){
        if anchor != nil{
            let constraint = centerYAnchor.constraint(equalTo: anchor!)
            if priority != 0{
                constraint.priority = UILayoutPriority(priority)
            }
            constraint.isActive = true
        }
    }
    
    public func setWidthAnchor(_ width: CGFloat, padding: CGFloat = 0,priority: Float = defaultPriority){
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    public func setWidthAnchor(_ anchor: NSLayoutDimension, padding: CGFloat = 0,priority: Float = defaultPriority){
        widthAnchor.constraint(equalTo: anchor, constant: padding) .isActive = true
    }
    
    public func setHeightAnchor(_ height: CGFloat,priority: Float = defaultPriority){
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    public func setHeightAnchor(_ anchor: NSLayoutDimension, padding: CGFloat = 0,priority: Float = defaultPriority){
        heightAnchor.constraint(equalTo: anchor, constant: padding) .isActive = true
    }
    
    public func setSquareAnchorByWidth(priority: Float = defaultPriority){
        let c = NSLayoutConstraint(item: self, attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .height,
                                   multiplier: 1, constant: 0)
        c.priority = UILayoutPriority(priority)
        self.addConstraint(c)
    }
    
    public func setSquareAnchorByHeight(priority: Float = defaultPriority){
        let c = NSLayoutConstraint(item: self, attribute: .height,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .width,
                                   multiplier: 1, constant: 0)
        c.priority = UILayoutPriority(priority)
        self.addConstraint(c)
    }
    
    public func removeAllConstraints(){
        for constraint in self.constraints{
            removeConstraint(constraint)
        }
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
