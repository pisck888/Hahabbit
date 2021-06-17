//
//  UIView+Extension.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/17.
//

import UIKit

extension UIView {

  var shakeKey: String { return "ShakeAnimation" }

  func shake() {

    layer.removeAnimation(forKey: shakeKey)

    let vals: [Double] = [-2, 2, -2, 2, 0]

    let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")

    translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

    translation.values = vals

    let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")

    rotation.values = vals.map { (degrees: Double) in

      let radians: Double = (Double.pi * degrees) / 180.0

      return radians
    }
    let shakeGroup = CAAnimationGroup()

    shakeGroup.animations = [translation, rotation]

    shakeGroup.duration = 0.3

    self.layer.add(shakeGroup, forKey: shakeKey)
  }

  func setCornerRadiusAndShadow() {

    self.layer.cornerRadius = 10

    self.layer.shadowOffset = CGSize(width: 2, height: 2)

    self.layer.shadowOpacity = 0.5

    self.layer.shadowRadius = 2

    self.layer.shadowColor = UIColor.black.cgColor
  }
}
