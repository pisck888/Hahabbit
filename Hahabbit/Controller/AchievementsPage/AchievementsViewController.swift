//
//  AchievementsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit

class AchievementsViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension AchievementsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsTableViewCell", for: indexPath) as! AchievementsTableViewCell
    cell.setCollectionViewHight(row: indexPath.row)
    cell.selectionStyle = .none
    return cell
  }
}

extension AchievementsViewController: UITableViewDelegate {
}
