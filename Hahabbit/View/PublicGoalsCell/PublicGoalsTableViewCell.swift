//
//  PublicGoalsTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit
import Kingfisher
import PopupDialog

class PublicGoalsTableViewCell: UITableViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var membersLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!

  @IBOutlet weak var ownerLabel: UILabel!
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var backView: UIView!
  @IBOutlet var weekdayButtons: [UIButton]!
  @IBOutlet weak var imageButton: UIButton!

  var habit: Habit?
  var name: String?
  var title: String?
  weak var viewController: UIViewController?

  override func awakeFromNib() {
    super.awakeFromNib()
    imageButton.layer.cornerRadius = imageButton.frame.width / 2
    avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
    avatarImage.layer.borderWidth = 1
    avatarImage.layer.borderColor = UIColor.black.cgColor
    backView.layer.cornerRadius = 10
    backView.layer.shadowOffset = CGSize(width: 2, height: 2)
    backView.layer.shadowOpacity = 0.5
    backView.layer.shadowRadius = 2
    backView.layer.shadowColor = UIColor.black.cgColor

  }

  @IBAction func tapImage(_ sender: UIButton) {
    if let habit = habit {

    }
    let popup = PopupDialog(
      title: name,
      message: title,
      image: avatarImage.image
    )
    let containerAppearance = PopupDialogContainerView.appearance()

    popup.transitionStyle = .zoomIn
    containerAppearance.cornerRadius = 10

    // Present dialog
    viewController?.present(popup, animated: true, completion: nil)
  }

  func setup(with publicHabit: Habit) {
    habit = publicHabit
    titleLabel.text = publicHabit.title
    locationLabel.text = "地點：" + publicHabit.location
    membersLabel.text = "\(publicHabit.members.count)人"

    for i in 0...6 {
      guard let staus = publicHabit.weekday["\(i + 1)"] else { return }
      weekdayButtons[i].isSelected = staus
    }

    UserManager.shared.db
      .collection("users")
      .whereField("id", isEqualTo: publicHabit.owner)
      .getDocuments { querySnapshot, error in
        guard error == nil else {
          print(error as Any)
          return
        }
        if let user = querySnapshot?.documents, !user.isEmpty,
           let title = user[0].data()["title"],
           let name = user[0].data()["name"],
           let url = URL(string: user[0].data()["image"] as? String ?? "") {
          self.ownerLabel.text = "發起人：[\(title)] \(name)"
          self.avatarImage.kf.setImage(with: url)
          self.name = name as? String
          self.title = title as? String
        }
      }
  }
}
