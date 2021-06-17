//
//  ProfileTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit
import Kingfisher

class ProfileTableViewCell: UITableViewCell {

  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var coinLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
    avatarImage.layer.borderWidth = 1
    avatarImage.layer.borderColor = UIColor.black.cgColor
    }

  func setup(user: User) {
    let url = URL(string: user.image)
    avatarImage.kf.setImage(with: url)
    nameLabel.text = user.name
    titleLabel.text = user.title
    coinLabel.text = String(user.coin)
  }
}
