//
//  PublicGoalsTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit

class PublicGoalsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var backView: UIView!
  override func awakeFromNib() {
    super.awakeFromNib()
    avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
    avatarImage.layer.borderWidth = 1
    avatarImage.layer.borderColor = UIColor.black.cgColor
    backView.layer.cornerRadius = 10
    backView.layer.borderWidth = 1
    backView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}

