//
//  AddNewGoalViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit

class AddNewGoalViewController: UIViewController {

  let addGoalTitle = ["運動健身", "學習技能", "自我管理", "其他自訂"]
  let imageArray = ["Fitness", "Designer", "Meditation", "Adventurer"]

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backButtonTitle = ""
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let typeNumber = sender as? Int else { return }
    if segue.identifier == "SegueToAddHabitDetail" {
      if let vc = segue.destination as? AddNewGoalDetailViewController {
        vc.type = String(typeNumber + 3)
      }
    }
  }
}

extension AddNewGoalViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    addGoalTitle.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.addNewGoalCell, for: indexPath) as? AddNewGoalCell
    cell?.titleLabel.text = addGoalTitle[indexPath.row]
    cell?.mainImage.image = UIImage(named: imageArray[indexPath.row])
    cell?.selectionStyle = .none
    return cell ?? AddNewGoalCell()
  }
}

extension AddNewGoalViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "SegueToAddHabitDetail", sender: indexPath.row)
  }
}
