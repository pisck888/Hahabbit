//
//  FrequencyCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit

class SelectableCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var lebel: UILabel!

  override func layoutSubviews() {
    self.layer.cornerRadius = 10
    self.layer.masksToBounds = true
  }

  func setup(string: String) {
    lebel.text = string
  }

  func setup(indexPath: IndexPath, reminders: [String]) {
    if indexPath.row != reminders.count - 1 {
      self.layer.borderWidth = 1
      self.layer.borderColor = UIColor.black.cgColor
      self.contentView.backgroundColor = UserManager.shared.themeColor.withAlphaComponent(0.3)
    } else {
      self.layer.borderWidth = 0
      self.contentView.backgroundColor = .systemGray6
    }
    lebel.text = reminders[indexPath.row]
  }
}
