//
//  AddNewGoalViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit
import Localize_Swift

class AddNewHabitViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.backButtonTitle = ""
    navigationItem.title = "建立新習慣".localized()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(setText),
      name: NSNotification.Name(LCLLanguageChangeNotification),
      object: nil
    )

  }

  @objc func setText() {
    navigationItem.title = "建立新習慣".localized()
    tableView.reloadData()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let typeNumber = sender as? Int else { return }
    if segue.identifier == MySegue.toAddNewHabitDetailPage {
      if let viewController = segue.destination as? AddNewHabitDetailViewController {
        viewController.type = String(typeNumber + 3)
      }
    }
  }
}

extension AddNewHabitViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    MyArray.habitTypeTitleArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: K.addNewGoalCell,
      for: indexPath) as? AddNewHabitTableViewCell else {
        return AddNewHabitTableViewCell()
    }
    cell.setup(
      title: MyArray.habitTypeTitleArray[indexPath.row].localized(),
      image: MyArray.habitTypeImageArray[indexPath.row]
    )
    return cell
  }
}

extension AddNewHabitViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: MySegue.toAddNewHabitDetailPage, sender: indexPath.row)
  }
}
