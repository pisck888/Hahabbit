//
//  BlacklistTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/4.
//

import UIKit
import Kingfisher

class BlacklistTableViewCell: UITableViewCell {

  @IBOutlet weak var userImage: UIImageView! {
    didSet {
      userImage.layer.cornerRadius = userImage.frame.width / 2
      userImage.clipsToBounds = true
    }
  }
  @IBOutlet weak var unblockButton: UIButton! {
    didSet {
      unblockButton.layer.cornerRadius = 10
    }
  }
  @IBOutlet weak var userName: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  func setup(blacklistUser: User) {
    let url = URL(string: blacklistUser.image)
    userImage.kf.setImage(with: url, placeholder: nil)
    userName.text = blacklistUser.name
  }
}
