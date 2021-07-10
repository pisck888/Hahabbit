//
//  MainPageTableViewCell.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit


class MainPageTableViewCell: UITableViewCell {

  @IBOutlet weak var backView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var sloganLabel: UILabel!
  @IBOutlet weak var checkButton: UIButton!
  @IBOutlet weak var iconImage: UIImageView!

  var id: String = ""
  let formatter = DateFormatter()
  var chosenDay = Date()

  override func awakeFromNib() {
    super.awakeFromNib()

    self.selectionStyle = .none

    formatter.dateFormat = "yyyyMMdd"

    backView.setCornerRadiusAndShadow()
  }

  func setup(with viewModel: HabitViewModel, date: Date = Date()) {

    chosenDay = date
    id = viewModel.id

    let stringDate = formatter.string(from: date)

    HabitManager.shared.database.collection("habits")
      .document(viewModel.id)
      .collection("isDone")
      .document(UserManager.shared.currentUser)
      .getDocument { documentSnapshot, error in
        guard error == nil else {
          print(error as Any)
          return
        }
        self.checkButton.isSelected = documentSnapshot?.data()?[stringDate] as? Bool ?? false
      }
    titleLabel.text = viewModel.title
    sloganLabel.text = viewModel.slogan
    iconImage.image = UIImage(named: viewModel.icon)
  }

  @IBAction func pressCheckButton(_ sender: UIButton) {
    let stringToday = formatter.string(from: Date())
    var stringDate = formatter.string(from: Date())
    stringDate = formatter.string(from: chosenDay)

    if stringDate == stringToday {
    AchievementsChecker.checker.checkAllAchievements(checked: sender.isSelected)
    }

    HabitManager.shared.database.collection("habits")
      .document(id)
      .collection("isDone")
      .document(UserManager.shared.currentUser)
      .setData([stringDate: !sender.isSelected], merge: true)

    sender.isSelected.toggle()

    ImpactFeedbackGenerator.impactOccurred()
  }
}
