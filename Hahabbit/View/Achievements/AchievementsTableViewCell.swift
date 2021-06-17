//
//  AchievementsDetailCellTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit

class AchievementsTableViewCell: UITableViewCell {

  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  @IBOutlet weak var rewardLabel: UILabel!

  override func awakeFromNib() {

    super.awakeFromNib()

    self.selectionStyle = .none

    mainImage.layer.cornerRadius = 10
    mainImage.clipsToBounds = true
    mainImage.theme_backgroundColor = ThemeColor.color

    backView.setCornerRadiusAndShadow()
  }

  func setup(achievement: Achievement) {
    titleLabel.text = achievement.title
    messageLabel.text = achievement.discription
    rewardLabel.text = String(achievement.reward)
    mainImage.image = UIImage(named: achievement.image)
  }
}
