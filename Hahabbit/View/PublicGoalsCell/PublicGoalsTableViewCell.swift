//
//  PublicGoalsTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit

class PublicGoalsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var membersLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var weekdayLabel: UILabel!
  @IBOutlet weak var ownerLabel: UILabel!
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var backView: UIView!
  @IBOutlet var weekdayButtons: [UIButton]!

  override func awakeFromNib() {
    super.awakeFromNib()
    avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
    avatarImage.layer.borderWidth = 1
    avatarImage.layer.borderColor = UIColor.black.cgColor
    backView.layer.cornerRadius = 10
    backView.layer.shadowOffset = CGSize(width: 2, height: 2)
    backView.layer.shadowOpacity = 0.5
    backView.layer.shadowRadius = 2
    backView.layer.shadowColor = UIColor.black.cgColor

  }

  func setup(with publicHabit: Habit) {
    titleLabel.text = publicHabit.title
    locationLabel.text = "地點：" + publicHabit.location
    membersLabel.text = "\(publicHabit.members.count)人已加入"

    for i in 0...6 {
      guard let staus = publicHabit.weekday["\(i + 1)"] else { return }
      weekdayButtons[i].isSelected = staus
    }

    HabitManager.shared.db
      .collection("users")
      .whereField("id", isEqualTo: publicHabit.owner)
      .getDocuments { querySnapshot, error in
        guard error == nil else {
          print(error)
          return
        }
        guard let title = querySnapshot?.documents[0].data()["title"],
              let name = querySnapshot?.documents[0].data()["name"] else {
          return
        }
        self.ownerLabel.text = "發起人：<\(title)> \(name)"
      }
  }
}
