//
//  MiniFilterView.swift
//  WhatToPlay
//
//  Created by Ryan LaSante on 7/6/18.
//  Copyright © 2018 rlasante. All rights reserved.
//

import UIKit

@IBDesignable class MiniFilterViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!

    @IBInspectable var cornerRadius: CGFloat = 6 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}

extension UIView {
    @IBInspectable var shadowOffsetY: CGFloat {
        set {
            if newValue > 0 {
                layer.shadowOffset = CGSize(width: 0, height: newValue)
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowRadius = 0
                layer.shadowOpacity = 0.5
            } else {
                layer.shadowOffset = CGSize(width: 0, height: 0)
                layer.shadowColor = nil
                layer.shadowOpacity = 0
            }
        }
        get {
            return layer.shadowOffset.height
        }
    }


//    @IBInspectable var borderColor: UIColor? {
//        set {
//            layer.borderColor = newValue?.cgColor
//            if newValue != nil {
//                layer.borderWidth = 1
//            } else {
//                layer.borderWidth = 0
//            }
//        }
//        get {
//            if let color = layer.borderColor {
//                return UIColor(cgColor: color)
//            } else {
//                return nil
//            }
//        }
//    }
}

class GradientView: UIView {
    override public class var layerClass: Swift.AnyClass {
        get {
            return CAGradientLayer.self
        }
    }

    private var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }

    @IBInspectable var startColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    @IBInspectable var vertical: Bool = true {
        didSet {
            updateDirection()
        }
    }

    @IBInspectable var endColor: UIColor? {
        didSet {
            updateColors()
        }
    }

    private func updateColors() {
        guard let start = startColor, let end = endColor else {
            gradientLayer.colors = nil
            return
        }
        gradientLayer.colors = [start.cgColor, end.cgColor]
    }

    private func updateDirection() {
        if vertical {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        }
    }
}
