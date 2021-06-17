//
//  BlacklistTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/4.
//

import UIKit
import Kingfisher

class BlocklistTableViewCell: UITableViewCell {

  @IBOutlet weak var userImage: UIImageView! {
    didSet {
      userImage.layer.cornerRadius = userImage.frame.width / 2
      userImage.clipsToBounds = true
    }
  }

  @IBOutlet weak var unblockButton: UIButton! {
    didSet {
      unblockButton.layer.cornerRadius = 10
      unblockButton.setTitle("解除封鎖".localized(), for: .normal)
      unblockButton.theme_backgroundColor = ThemeColor.color
    }
  }

  @IBOutlet weak var userName: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
  }

  func setup(blocklistUser: User) {
    let url = URL(string: blocklistUser.image)
    userImage.kf.setImage(with: url, placeholder: nil)
    userName.text = blocklistUser.name
  }
}
