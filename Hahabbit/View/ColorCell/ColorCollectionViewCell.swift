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
    colorView.layer.cornerRadius = colorView.frame.width / 2
    colorView.backgroundColor = color
    selectedImage.alpha = 0
  }
}
