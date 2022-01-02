//
//  UIView+Extensions.swift
//
//  Created by Muhammet İkbal Yaşar 
//

import Foundation
import UIKit
import QuartzCore

extension UIView {
    // MARK: Gölge
    @IBInspectable var shadow: Bool {
        get {
            return layer.shadowOpacity > 0.0
        }
        set {
            if newValue == true {
                self.addShadow()
            }
        }
    }
    // MARK: Kenar açısı
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            if shadow == false {
                self.layer.masksToBounds = true
            }
        }
    }

    // MARK:  Arka Plana Shadow verme
    func addShadow(opacitiy : Float, shadowRadius:CGFloat, shadowOffsetWidth:Int, shadowOffsetHeight:Int, shadowColor: UIColor, backgroundColor: UIColor) {
        clipsToBounds = false
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = opacitiy
        self.layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        self.layer.shadowRadius = shadowRadius
        self.layer.backgroundColor = backgroundColor.cgColor
        
    }
    
    func addShadow(shadowColor: CGColor = UIColor.darkGray.cgColor,
                   shadowOffset: CGSize = CGSize(width: 0.0, height: 2.0),
                   shadowOpacity: Float = 0.5,
                   shadowRadius: CGFloat = 2.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        clipsToBounds = false
        self.layer.masksToBounds = false
    }
    
    
    // MARK:  Border e renk ve genişlik verme
    func addBorderCornerViewColor(width:CGFloat,color:UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        
    }
    
    func addCornerRadius(cornerRadius:CGFloat) {
        self.layer.cornerRadius = cornerRadius
        clipsToBounds = false
    }
    
    func rotate360Degrees(duration: CFTimeInterval = 0.3, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.duration = duration
        
        if let delegate: CAAnimationDelegate = completionDelegate as! CAAnimationDelegate? {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
}
