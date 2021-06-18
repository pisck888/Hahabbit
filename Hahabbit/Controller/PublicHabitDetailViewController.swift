//
//  PublicGoalsDetailViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/19.
//

import UIKit
import Firebase
import JGProgressHUD
import Localize_Swift

class PublicHabitDetailViewController: UIViewController {

  var habit: Habit?

  @IBOutlet weak var joinButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "習慣細節".localized()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(setText),
      name: NSNotification.Name(LCLLanguageChangeNotification),
      object: nil
    )
    setJoinButton()
  }

  @objc func setText() {
    navigationItem.title = "習慣細節".localized()
    joinButton.setTitle("加入".localized(), for: .normal)
  }

  func setJoinButton() {
    joinButton.layer.cornerRadius = 10
    joinButton.setTitle("加入".localized(), for: .normal)
    joinButton.theme_backgroundColor = ThemeColor.color
  }

  @IBAction func pressButton(_ sender: UIButton) {
    if let habit = habit {
      HabitManager.shared.db.collection("habits")
        .document(habit.id)
        .updateData(
          ["members": FieldValue.arrayUnion([UserManager.shared.currentUser])]
        )
      HabitManager.shared.db.collection("chats")
        .document(habit.id)
        .updateData(
          ["members": FieldValue.arrayUnion([UserManager.shared.currentUser])]
        )
    }
    navigationController?.popViewController(animated: true)
    let hud = JGProgressHUD()
    hud.textLabel.text = "完成".localized()
    hud.square = true
    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
    hud.show(in: (self.navigationController?.view)!, animated: true)
    hud.dismiss(afterDelay: 1.5)
  }

}

extension PublicHabitDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: K.publicHabitDetailCell,
      for: indexPath
    ) as? PublicHabitDetailCell,
    let habit = habit else {
      return PublicHabitDetailCell()
    }
    cell.setup(with: habit)
    return cell
  }
}
