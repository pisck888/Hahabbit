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

  var id: String = ""
  let date = Date()
  let formatter = DateFormatter()

  override func awakeFromNib() {
    super.awakeFromNib()
    backView.layer.cornerRadius = 10
    backView.layer.borderWidth = 1
    backView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
  }

  func setup(with viewModel: HabitViewModel) {

    formatter.dateFormat = "yyyyMMdd"
    let today = formatter.string(from: date)

    HabitManager.shared.db.collection("habits")
      .document(viewModel.id)
      .collection("isDone")
      .document(HabitManager.shared.currentUser)
      .getDocument { documentSnapshot, error in
        guard error == nil else {
          print(error!)
          return
        }
        print(viewModel.title, documentSnapshot?.data()?["date" + today])
        self.checkButton.isSelected = documentSnapshot?.data()?["date" + today] as? Bool ?? false
      }
    titleLabel.text = viewModel.title
    sloganLabel.text = viewModel.slogan
    id = viewModel.id
  }

  @IBAction func pressCheckButton(_ sender: UIButton) {
    formatter.dateFormat = "yyyyMMdd"
    let today = formatter.string(from: date)

    HabitManager.shared.db.collection("habits")
      .document(id)
      .collection("isDone")
      .document(HabitManager.shared.currentUser)
      .setData(["date" + today: !sender.isSelected], merge: true)
//    print(id,!sender.isSelected)
    sender.isSelected.toggle()
  }
}
