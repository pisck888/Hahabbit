//
//  SignOutTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/10.
//

import UIKit

class SignOutTableViewCell: UITableViewCell {

  @IBOutlet weak var signOutLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.contentView.theme_backgroundColor = ThemeColor.color
    self.selectionStyle = .none
  }
  
  func setup(string: String) {
    signOutLabel.text = string
  }
}
