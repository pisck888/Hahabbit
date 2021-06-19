//
//  AllHabitsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/6/11.
//

import UIKit
import Localize_Swift
import PopupDialog

class AllHabitsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  let viewModel = AllHabitsViewModel()
  let generator = UIImpactFeedbackGenerator(style: .light)

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.backButtonTitle = ""
    navigationItem.title = "所有習慣".localized()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(setText),
      name: NSNotification.Name(LCLLanguageChangeNotification),
      object: nil
    )

    tableView.register(
      UINib(nibName: K.mainPageTableViewCell, bundle: nil),
      forCellReuseIdentifier: K.mainPageTableViewCell
    )

    viewModel.refreshView = { [weak self] () in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }

    viewModel.habitViewModels.bind { [weak self] _ in
      self?.viewModel.onRefresh()
    }

    viewModel.fetchData()
  }

  @objc func setText() {
    navigationItem.title = "所有習慣".localized()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let controller = segue.destination as? HabitDetailViewController
    if segue.identifier == MySegue.toHabitDetailPage {
      controller?.habit = sender as? HabitViewModel
    }
  }
}

extension AllHabitsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.habitViewModels.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(
        withIdentifier: K.mainPageTableViewCell,
        for: indexPath
    ) as? MainPageTableViewCell {
      let cellViewModel = viewModel.habitViewModels.value[indexPath.row]
      cell.setup(with: cellViewModel)
      cell.checkButton.isHidden = true
      return cell
    } else {
      return MainPageTableViewCell()
    }
  }
}

extension AllHabitsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let habit = viewModel.habitViewModels.value[indexPath.row]
    performSegue(withIdentifier: MySegue.toHabitDetailPage, sender: habit)
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .normal, title: nil) { _, _, completionHandler in

      let popup = PopupDialog(
        title: "確定要刪除習慣嗎？".localized(),
        message: "刪除以後無法復原囉".localized()
      )
      let deleteButton = DestructiveButton(title: "刪除".localized()) {
        if UserManager.shared.isHapticFeedback {
          self.generator.impactOccurred()
        }
        HabitManager.shared.deleteHabit(habit: self.viewModel.habitViewModels.value[indexPath.row].habit)
          self.viewModel.habitViewModels.value.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .fade)
      }

      let cancelButton = CancelButton(title: "取消".localized()) {
      }

      popup.addButtons([deleteButton, cancelButton])
      popup.transitionStyle = .zoomIn
      PopupDialogContainerView.appearance().cornerRadius = 10

      self.present(popup, animated: true, completion: nil)

      if UserManager.shared.isHapticFeedback {
        self.generator.impactOccurred()
      }

      completionHandler(true)
    }

    deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
      UIImage(named: "delete")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25))
    }

    deleteAction.backgroundColor = .systemGray6

    let configuration = UISwipeActionsConfiguration(actions: [deleteAction])

    configuration.performsFirstActionWithFullSwipe = false

    return configuration
  }
}
