//
//  AchievementsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit

class AchievementsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var gridModeButton: UIBarButtonItem!
  

  let viewModel = AchievementViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    gridModeButton.isEnabled = false
    gridModeButton.tintColor = .clear

    viewModel.userAchievements.bind { achievements in
      self.tableView.reloadData()
    }

    viewModel.dailyAchievements.bind { achievements in
      self.tableView.reloadData()
    }

    viewModel.specialAchievements.bind { achievements in
      self.tableView.reloadData()
    }

    viewModel.fetchData()
  }
}

extension AchievementsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "我已達成"
    case 1:
      return "每日任務"
    default:
      return "特殊成就"
    }
  }

  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.contentView.backgroundColor = .systemGray6
    header.textLabel?.font = UIFont(name: "PingFangTC-Medium", size: 16)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return viewModel.userAchievements.value.count
    case 1:
      return viewModel.dailyAchievements.value.count
    default:
      return viewModel.specialAchievements.value.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsTableViewCell", for: indexPath) as! AchievementsTableViewCell
    cell.selectionStyle = .none
    switch indexPath.section {
    case 0:
      cell.setup(achievement: viewModel.userAchievements.value[indexPath.row])
    case 1:
      cell.setup(achievement: viewModel.dailyAchievements.value[indexPath.row])
    default:
      cell.setup(achievement: viewModel.specialAchievements.value[indexPath.row])
    }
    return cell
  }
}

extension AchievementsViewController: UITableViewDelegate {
}
