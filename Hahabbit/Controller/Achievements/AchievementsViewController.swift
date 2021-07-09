//
//  AchievementsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit
import Localize_Swift

class AchievementsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var gridModeButton: UIBarButtonItem!

  let viewModel = AchievementViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    gridModeButton.isEnabled = false
    gridModeButton.tintColor = .clear

    navigationItem.title = "成就統計".localized()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(setText),
      name: NSNotification.Name(LCLLanguageChangeNotification),
      object: nil
    )

    viewModel.userAchievements.bind { [unowned self] _ in
      self.tableView.reloadData()
    }

    viewModel.dailyAchievements.bind { [unowned self] _ in
      self.tableView.reloadData()
    }

    viewModel.specialAchievements.bind { [unowned self] _ in
      self.tableView.reloadData()
    }

    viewModel.fetchData()
  }

  @objc func setText() {
    navigationItem.title = "成就統計".localized()
    tableView.reloadData()
  }
}

extension AchievementsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "我已達成".localized()
    case 1:
      return "每日任務".localized()
    default:
      return "特殊成就".localized()
    }
  }

  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let header = view as? UITableViewHeaderFooterView {
      header.contentView.backgroundColor = .systemGray6
      header.textLabel?.font = UIFont(name: "PingFangTC-Medium", size: 16)
    }
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
    let cell: AchievementsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
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
