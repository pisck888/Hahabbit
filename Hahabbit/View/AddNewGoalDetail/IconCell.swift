//
//  IconCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit

class IconCell: UICollectionViewCell {
    
  @IBOutlet weak var iconImage: UIImageView!
  override func layoutSubviews() {
    self.layer.cornerRadius = 10
    self.layer.masksToBounds = true
  }
}
