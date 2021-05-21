//
//  AchievementsDetailCellTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit

class AchievementsDetailTableViewCell: UITableViewCell {
  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    backView.layer.cornerRadius = 10
    backView.layer.borderColor = UIColor.black.cgColor
    backView.layer.borderWidth = 1
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
