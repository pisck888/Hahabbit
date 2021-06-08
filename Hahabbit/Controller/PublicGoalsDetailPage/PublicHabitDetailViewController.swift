//
//  PublicGoalsDetailViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/19.
//

import UIKit
import Firebase
import JGProgressHUD

class PublicHabitDetailViewController: UIViewController {

  var habit: Habit?

  @IBOutlet weak var joinButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    joinButton.layer.cornerRadius = 10
  }

  @IBAction func pressButton(_ sender: UIButton) {
    if let habit = habit {
      HabitManager.shared.db.collection("habits")
        .document(habit.id)
        .updateData(
          ["members": FieldValue.arrayUnion([UserManager.shared.currentUser])]
        )
    }
    navigationController?.popViewController(animated: true)
    let hud = JGProgressHUD()
    hud.textLabel.text = "完成"
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "PublicHabitDetailCell", for: indexPath) as! PublicHabitDetailCell
    if let habit = habit {
      cell.setup(with: habit)
    }
    cell.selectionStyle = .none
    return cell
  }


}
