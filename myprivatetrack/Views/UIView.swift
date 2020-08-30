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
    
    public func placeBelow(anchor: NSLayoutYAxisAnchor, padding: UIEdgeInsets = Statics.defaultInsets){
        enableAnchors()
        setTopAnchor(anchor,padding: padding.top)
        setLeadingAnchor(superview?.leadingAnchor,padding: padding.left)
        setTrailingAnchor(superview?.trailingAnchor, padding: padding.right)
    }
    
    public func placeBelow(view: UIView, padding: UIEdgeInsets = Statics.defaultInsets){
        placeBelow(anchor: view.bottomAnchor, padding: padding)
    }
    
    public func placeAbove(anchor: NSLayoutYAxisAnchor, padding: UIEdgeInsets = Statics.defaultInsets){
        enableAnchors()
        setBottomAnchor(anchor,padding: padding.top)
        setLeadingAnchor(superview?.leadingAnchor,padding: padding.left)
        setTrailingAnchor(superview?.trailingAnchor, padding: padding.right)
    }
    
    public func placeAbove(view: UIView, padding: UIEdgeInsets = Statics.defaultInsets){
        placeAbove(anchor: view.topAnchor, padding: padding)
    }
    
    public func connectBottom(view: UIView, padding: CGFloat = Statics.defaultInset){
        setBottomAnchor(view.bottomAnchor, padding: padding)
    }
    
    public func placeBefore(anchor: NSLayoutXAxisAnchor, padding: UIEdgeInsets = Statics.defaultInsets){
        enableAnchors()
        setTrailingAnchor(anchor,padding: padding.right)
        setTopAnchor(superview?.topAnchor,padding: padding.top)
        setBottomAnchor(superview?.bottomAnchor, padding: padding.bottom)
    }
    
    public func placeBefore(view: UIView, padding: UIEdgeInsets = Statics.defaultInsets){
        placeBefore(anchor: view.leadingAnchor, padding: padding)
    }
    
    public func placeAfter(anchor: NSLayoutXAxisAnchor, padding: UIEdgeInsets = Statics.defaultInsets){
        enableAnchors()
        setLeadingAnchor(anchor,padding: padding.left)
        setTopAnchor(superview?.topAnchor,padding: padding.top)
        setBottomAnchor(superview?.bottomAnchor, padding: padding.bottom)
    }
    
    public func placeAfter(view: UIView, padding: UIEdgeInsets = Statics.defaultInsets){
        placeAfter(anchor: view.trailingAnchor, padding: padding)
    }
    
    public func placeXCentered(padding: UIEdgeInsets = Statics.defaultInsets){
        enableAnchors()
        setCenterXAnchor(superview?.centerXAnchor)
        setTopAnchor(superview?.topAnchor,padding: padding.top)
        setBottomAnchor(superview?.bottomAnchor, padding: padding.bottom)
    }
    
    public func placeTopRight(padding: UIEdgeInsets = Statics.defaultInsets){
        enableAnchors()
        setTopAnchor(superview?.topAnchor, padding: padding.top)
        setTrailingAnchor(superview?.trailingAnchor, padding: padding.right)
    }
    
    public func enableAnchors(){
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func setLeadingAnchor(_ anchor: NSLayoutXAxisAnchor?, padding: CGFloat = 0){
        if let anchor = anchor{
        leadingAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
        }
    }
    
    public func setTrailingAnchor(_ anchor: NSLayoutXAxisAnchor?, padding: CGFloat = 0){
        if let anchor = anchor{
            trailingAnchor.constraint(equalTo: anchor, constant: -padding).isActive = true
        }
    }
    
    public func setTopAnchor(_ anchor: NSLayoutYAxisAnchor?, padding: CGFloat = 0){
        if let anchor = anchor{
            topAnchor.constraint(equalTo: anchor, constant: padding).isActive = true
        }
    }
    
    public func setBottomAnchor(_ anchor: NSLayoutYAxisAnchor?, padding: CGFloat = 0){
        if let anchor = anchor{
            bottomAnchor.constraint(equalTo: anchor, constant: -padding).isActive = true
        }
    }
    
    public func setCenterXAnchor(_ anchor: NSLayoutXAxisAnchor?){
        if anchor != nil{
            centerXAnchor.constraint(equalTo: anchor!) .isActive = true
        }
    }
    
    public func setCenterYAnchor(_ anchor: NSLayoutYAxisAnchor?){
        if anchor != nil{
            centerYAnchor.constraint(equalTo: anchor!) .isActive = true
        }
    }
    
    public func setWidthAnchor(_ width: CGFloat, padding: CGFloat = 0){
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    public func setWidthAnchor(_ anchor: NSLayoutDimension, padding: CGFloat = 0){
        widthAnchor.constraint(equalTo: anchor, constant: padding) .isActive = true
    }
    
    public func setHeightAnchor(_ height: CGFloat){
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    public func setHeightAnchor(_ anchor: NSLayoutDimension, padding: CGFloat = 0){
        heightAnchor.constraint(equalTo: anchor, constant: padding) .isActive = true
    }
    
    public func setSquareAnchorByWidth(){
        let c = NSLayoutConstraint(item: self, attribute: .width,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .height,
                                   multiplier: 1, constant: 0)
        c.priority = UILayoutPriority(900)
        self.addConstraint(c)
    }
    
    public func setSquareAnchorByHeight(){
        let c = NSLayoutConstraint(item: self, attribute: .height,
                                   relatedBy: .equal,
                                   toItem: self, attribute: .width,
                                   multiplier: 1, constant: 0)
        c.priority = UILayoutPriority(900)
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
