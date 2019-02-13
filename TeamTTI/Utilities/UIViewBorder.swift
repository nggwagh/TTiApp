//
//  UIViewBorder.swift
//  TeamTTI
//
//  Created by Mohini Mehetre on 19/12/18.
//  Copyright © 2018 TeamTTI. All rights reserved.
//

import UIKit

enum ViewBorder: String {
    case left, right, top, bottom
}

extension UIView {
    
    func add(border: ViewBorder, color: UIColor, width: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        borderLayer.name = border.rawValue
        switch border {
        case .left:
            borderLayer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            borderLayer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        case .top:
            borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        case .bottom:
            borderLayer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        }
        self.layer.addSublayer(borderLayer)
    }
    
    func remove(border: ViewBorder) {
        guard let sublayers = self.layer.sublayers else { return }
        var layerForRemove: CALayer?
        for layer in sublayers {
            if layer.name == border.rawValue {
                layerForRemove = layer
            }
        }
        if let layer = layerForRemove {
            layer.removeFromSuperlayer()
        }
    }
    
    func dropShadow(color: UIColor, shadowOpacity: Float = 0.5, shadowSize: CGFloat = 1) {
        let frame = CGRect(x: -shadowSize, y: -shadowSize, width: (self.frame.width + (2 * shadowSize)) , height: (self.frame.height + (2 * shadowSize)))
        let shadowPath = UIBezierPath(rect: frame)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
    func removeShadow() {
        layer.shadowColor = UIColor.clear.cgColor
    }
    
}
