//
//  PublicHabitDetailCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/24.
//

import UIKit
import Kingfisher

class PublicHabitDetailCell: UITableViewCell {

  @IBOutlet weak var detailBackView: UIView!
  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var sloganLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var memberNumbersLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet var weekdayButtons: [UIButton]!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.selectionStyle = .none
    mainImage.layer.cornerRadius = 10
    detailBackView.setCornerRadiusAndShadow()
  }

  func setup(with habit: Habit) {
    let url = URL(string: habit.photo)

    titleLabel.text = habit.title
    sloganLabel.text = habit.slogan
    locationLabel.text = "地點：\(habit.location)"
    memberNumbersLabel.text = "\(habit.members.count)人已加入"
    detailLabel.text = habit.detail
    mainImage.kf.setImage(with: url)
    iconImage.image = UIImage(named: habit.icon)

    for i in 0...6 {
      guard let staus = habit.weekday["\(i + 1)"] else { return }
      weekdayButtons[i].isSelected = staus
      weekdayButtons[i].theme_tintColor = ThemeColor.color
    }
  }
}
