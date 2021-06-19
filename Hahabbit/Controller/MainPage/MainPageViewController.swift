//
//  ViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/12.
//

import UIKit
import PinterestSegment
import PopupDialog
import Localize_Swift

class MainPageViewController: UIViewController {

  @IBOutlet weak var segmentView: UIView!
  @IBOutlet weak var tableView: UITableView!

  let generator = UIImpactFeedbackGenerator(style: .light)
  var segment = PinterestSegment()
  let viewModel = HomeViewModel()
  var type = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    // setup Segment
    setupPinterestSegment()

    // setup Navigation Bar
    navigationItem.backButtonTitle = ""
    navigationItem.title = "今天".localized()

    // add Notification Observer
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(setText),
      name: NSNotification.Name(LCLLanguageChangeNotification),
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(setThemeColor),
      name: NSNotification.Name(K.changeThemeColor),
      object: nil
    )

    HabitManager.shared.setAllNotifications()

    UserManager.shared.fetchUserSignUpDate()

    viewModel.refreshView = { [weak self] () in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }

    viewModel.habitViewModels.bind { [weak self] _ in
      self?.viewModel.onRefresh()
    }

    tableView.register(
      UINib(nibName: K.mainPageTableViewCell, bundle: nil),
      forCellReuseIdentifier: K.mainPageTableViewCell
    )
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    AchievementsChecker.checker.delegate = self
    viewModel.fetchData(type: type)
  }

  @objc func setText() {
    navigationItem.title = "今天".localized()
    segment.titles = MyArray.mainPageTag.map { $0.localized() }
  }

  @objc func setThemeColor() {
    segment.style.indicatorColor = UserManager.shared.themeColor
  }

  func setupPinterestSegment() {
    var style = PinterestSegmentStyle()
    style.indicatorColor = UserManager.shared.themeColor
    style.titleMargin = 6
    style.titlePendingHorizontal = 14
    style.titlePendingVertical = 14
    style.titleFont = UIFont.boldSystemFont(ofSize: 14)
    style.normalTitleColor = .gray
    style.selectedTitleColor = .white

    segment = PinterestSegment(
      frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50),
      segmentStyle: style,
      titles: MyArray.mainPageTag.map { $0.localized() }
    )

    segmentView.addSubview(segment)

    segment.valueChange = { index in
      self.type = index
      self.viewModel.fetchData(type: index)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let controller = segue.destination as? HabitDetailViewController
    if segue.identifier == MySegue.toHabitDetailPage {
      controller?.habit = sender as? HabitViewModel
    }
  }
}

// MARK: - UITableView DataSource and Delegate
extension MainPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.habitViewModels.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: K.mainPageTableViewCell,
      for: indexPath
    ) as? MainPageTableViewCell else {
      return MainPageTableViewCell()
    }
    let cellViewModel = viewModel.habitViewModels.value[indexPath.row]
    cell.setup(with: cellViewModel)
    return cell
  }
}

extension MainPageViewController: UITableViewDelegate {
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
        // delete habit in db and datasource
        HabitManager.shared.deleteHabit(habit: self.viewModel.habitViewModels.value[indexPath.row].habit)

        self.viewModel.habitViewModels.value.remove(at: indexPath.row)

        tableView.deleteRows(at: [indexPath], with: .fade)
      }

      let cancelButton = CancelButton(title: "取消".localized()) {
      }

      popup.addButtons([deleteButton, cancelButton])
      popup.transitionStyle = .zoomIn
      PopupDialogContainerView.appearance().cornerRadius = 10

      // Present dialog
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

// MARK: - AchievementsCheckerDelegate
extension MainPageViewController: AchievementsCheckerDelegate {
  func showPopupView(title: String, message: String, image: String) {
    let mainImage = UIImage(named: image)?.withBackground(color: UserManager.shared.themeColor)
    let popup = PopupDialog(
      title: title,
      message: message,
      image: mainImage
    )

    popup.transitionStyle = .zoomIn
    PopupDialogContainerView.appearance().cornerRadius = 10

    self.present(popup, animated: true) {
      popup.shake()
    }
  }
}
