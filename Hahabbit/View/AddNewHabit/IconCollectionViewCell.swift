//
//  IconCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var iconImage: UIImageView!

  var imageName: String?

  override func layoutSubviews() {
    self.layer.backgroundColor = UIColor.systemGray5.cgColor
    self.layer.cornerRadius = 10
    self.layer.masksToBounds = true
  }

  func setup(imageName: String) {
    self.imageName = imageName
    iconImage.image = UIImage(named: imageName)
  }
}
