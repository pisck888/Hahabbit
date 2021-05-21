//
//  PublicGoalsDetailViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/19.
//

import UIKit

class PublicGoalsDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension PublicGoalsDetailViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PublicGoalsDetailCell", for: indexPath)
    cell.selectionStyle = .none
    return cell
  }


}
extension PublicGoalsDetailViewController: UITableViewDelegate {

}
