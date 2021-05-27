//
//  FrequencyCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit

class FrequencyCell: UICollectionViewCell {
    
  @IBOutlet weak var lebel: UILabel!

  override func layoutSubviews() {
    self.layer.cornerRadius = 10
    self.layer.masksToBounds = true
  }

  func setup(string: String) {
    lebel.text = string
  }
}
