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
  let formatter = DateFormatter()
  var chosenDay = Date()

  override func awakeFromNib() {
    super.awakeFromNib()

    formatter.dateFormat = "yyyyMMdd"

    backView.layer.cornerRadius = 10
    backView.layer.borderWidth = 1
    backView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

    backView.layer.shadowOffset = CGSize(width: 2, height: 2)
    backView.layer.shadowOpacity = 0.3
    backView.layer.shadowRadius = 2
    backView.layer.shadowColor = UIColor.black.cgColor
  }

  func setup(with viewModel: HabitViewModel, date: Date = Date()) {

    chosenDay = date
    id = viewModel.id

    let stringDate = formatter.string(from: date)

    HabitManager.shared.db.collection("habits")
      .document(viewModel.id)
      .collection("isDone")
      .document(HabitManager.shared.currentUser)
      .getDocument { documentSnapshot, error in
        guard error == nil else {
          print(error!)
          return
        }
        self.checkButton.isSelected = documentSnapshot?.data()?[stringDate] as? Bool ?? false
        print(viewModel.title, stringDate, documentSnapshot?.data()?[stringDate])
      }
    titleLabel.text = viewModel.title
    sloganLabel.text = viewModel.slogan
  }

  @IBAction func pressCheckButton(_ sender: UIButton) {

    HabitManager.shared.db.collection("achievements")
      .whereField("id", isEqualTo: 0)
      .getDocuments { querySnapshot, error in
        print(querySnapshot?.documents[0].data())
      }

    let stringDate = formatter.string(from: chosenDay)

    HabitManager.shared.db.collection("habits")
      .document(id)
      .collection("isDone")
      .document(HabitManager.shared.currentUser)
      .setData([stringDate: !sender.isSelected], merge: true)

    sender.isSelected.toggle()
  }
}
