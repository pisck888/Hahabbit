//
//  AllAchievementsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/18.
//

import UIKit

class AllAchievementsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension AllAchievementsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsDetailCell", for: indexPath) as! AchievementsDetailTableViewCell
    return cell
  }


}
extension AllAchievementsViewController: UITableViewDelegate {

}
