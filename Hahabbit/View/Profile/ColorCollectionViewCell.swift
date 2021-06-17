//
//  ColorCollectionViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/12.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var selectedImage: UIImageView!
  @IBOutlet weak var colorView: UIView!

  func setup(color: UIColor) {
    self.layoutIfNeeded()
    colorView.layer.cornerRadius = colorView.frame.width / 2
    colorView.backgroundColor = color
    if self.isSelected {
      selectedImage.alpha = 1
    } else {
      selectedImage.alpha = 0
    }
  }
}
