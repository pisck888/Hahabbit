//
//  AddNewGoalViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit
import Localize_Swift

class AddNewhHabitViewController: UIViewController {

  let imageArray = ["Fitness", "Designer", "Meditation", "Adventurer"]

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.backButtonTitle = ""
    navigationItem.title = "建立新習慣".localized()
    NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

  }
  @objc func setText() {
    navigationItem.title = "建立新習慣".localized()
    tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let typeNumber = sender as? Int else { return }
    if segue.identifier == "SegueToAddHabitDetail" {
      if let vc = segue.destination as? AddNewHabitDetailViewController {
        vc.type = String(typeNumber + 3)
      }
    }
  }
}

extension AddNewhHabitViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    MyArray.addGoalTitle.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.addNewGoalCell, for: indexPath) as? AddNewGoalCell
    cell?.titleLabel.text = MyArray.addGoalTitle[indexPath.row].localized()
    cell?.mainImage.image = UIImage(named: imageArray[indexPath.row])
    cell?.selectionStyle = .none
    return cell ?? AddNewGoalCell()
  }
}

extension AddNewhHabitViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "SegueToAddHabitDetail", sender: indexPath.row)
  }
}
