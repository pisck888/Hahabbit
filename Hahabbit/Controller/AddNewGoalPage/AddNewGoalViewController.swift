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
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.addNewGoalCell, for: indexPath) as? AddNewGoalCell
    //    cell?.selectionStyle = .none
    return cell ?? AddNewGoalCell()
  }
}

extension AddNewGoalViewController: UITableViewDelegate {
}
