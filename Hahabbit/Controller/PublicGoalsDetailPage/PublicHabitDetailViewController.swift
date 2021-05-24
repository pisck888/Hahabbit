//
//  PublicGoalsDetailViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/19.
//

import UIKit

class PublicHabitDetailViewController: UIViewController {

  var habit: Habit?

  @IBOutlet weak var joinButton: UIButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    joinButton.layer.cornerRadius = 10
    print(habit)
  }

  @IBAction func pressButton(_ sender: UIButton) {
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
