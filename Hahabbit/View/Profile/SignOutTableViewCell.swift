//
//  SignOutTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/10.
//

import UIKit

class SignOutTableViewCell: UITableViewCell {

  @IBOutlet weak var signOutLabel: UILabel!
  func setup(string: String) {
    signOutLabel.text = string
    
  }
}
