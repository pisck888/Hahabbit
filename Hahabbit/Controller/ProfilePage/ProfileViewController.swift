//
//  SettingsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension ProfileViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    4
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return 3
    case 2:
      return 2
    default:
      return 5
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
      cell.selectionStyle = .none
      return cell
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
      cell.selectionStyle = .none
      return cell
    }
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "個人資訊"
    case 1:
      return "畫面設定"
    case 2:
      return "通知設定"
    default:
      return "隱私設定"
    }
  }


}
extension ProfileViewController: UITableViewDelegate {

}
