//
//  SettingsTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!

  func setup(string: String, indexPathRow: Int) {
    titleLabel.text = string.localized()
    if indexPathRow == 3 {
      switch UserManager.shared.isHapticFeedback {
      case true:
        detailLabel.text = "開啟".localized()
      case false:
        detailLabel.text = "關閉".localized()
      }
    }
  }
}
