//
//  extension.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/2.
//

import UIKit

extension UIImage {

  func resized(to size: CGSize) -> UIImage {

    return UIGraphicsImageRenderer(size: size).image { _ in

      draw(in: CGRect(origin: .zero, size: size))
    }
  }

  func withBackground(color: UIColor, opaque: Bool = true) -> UIImage {

    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)

    guard let ctx = UIGraphicsGetCurrentContext(), let image = cgImage else {
      return self
    }

    defer { UIGraphicsEndImageContext() }

    let rect = CGRect(origin: .zero, size: size)

    ctx.setFillColor(color.cgColor)

    ctx.fill(rect)

    ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))

    ctx.draw(image, in: rect)

    return UIGraphicsGetImageFromCurrentImageContext() ?? self
  }

}
