//
//  AddNewGoalViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit

class AddNewGoalViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension AddNewGoalViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    4
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.addNewGoalCell, for: indexPath) as? AddNewGoalCell
    cell?.label.text = MockData.addGoalTitle[indexPath.section]
    cell?.selectionStyle = .none
    return cell ?? AddNewGoalCell()
  }
}

extension AddNewGoalViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    16
  }
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
    view.tintColor = .white
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }
}
