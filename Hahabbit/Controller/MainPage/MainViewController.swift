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

class MainViewController: UIViewController {

  @IBOutlet var popupView: UIView!
  @IBOutlet weak var popupImage: UIImageView!
  @IBOutlet weak var popupTitleLabel: UILabel!
  @IBOutlet weak var popupMessageLabel: UILabel!
  @IBOutlet weak var closeButton: UIButton!

  @IBOutlet weak var segmentView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var gridModeButton: UIBarButtonItem!

  lazy var blurView: UIView = {
    let blurView = UIView(frame: view.frame)
    blurView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    return blurView
  }()

  var style = PinterestSegmentStyle()
  var segment = PinterestSegment()
  let viewModel = HomeViewModel()
  var type = 0

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.backButtonTitle = ""
    navigationItem.title = "今天".localized()
    gridModeButton.isEnabled = false
    gridModeButton.tintColor = .clear

    NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

    AchievementsChecker.checker.delegate = self

    HabitManager.shared.setAllNotifications()
    UserManager.shared.fetchUserSignUpDate {
    }

    viewModel.refreshView = { [weak self] () in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    viewModel.habitViewModels.bind { [weak self] habits in
      self?.viewModel.onRefresh()
    }

    tableView.register(UINib(nibName: K.mainPageTableViewCell, bundle: nil), forCellReuseIdentifier: K.mainPageTableViewCell)

    setPinterestSegment()
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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    viewModel.fetchData(type: type)
  }

  @objc func setText() {
    navigationItem.title = "今天".localized()
    segment.titles = MyArray.mainPageTag.map { $0.localized() }
  }

  func setPinterestSegment() {
    style.indicatorColor = .darkGray
    style.titleMargin = 6
    style.titlePendingHorizontal = 14
    style.titlePendingVertical = 14
    style.titleFont = UIFont.boldSystemFont(ofSize: 14)
    style.normalTitleColor = .darkGray
    style.selectedTitleColor = .white
  }
  @IBAction func pressCloseButton(_ sender: UIButton) {
    blurView.removeFromSuperview()
    popupView.removeFromSuperview()
  }

  @IBAction func test(_ sender: UIBarButtonItem) {
  }


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let controller = segue.destination as? HabitDetailViewController
    if segue.identifier == "SegueToDetail" {
      controller?.habit = sender as? HabitViewModel
    }
  }
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.habitViewModels.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: K.mainPageTableViewCell, for: indexPath) as? MainPageTableViewCell else {
      return MainPageTableViewCell()
    }
    let cellViewModel = viewModel.habitViewModels.value[indexPath.row]
    cell.setup(with: cellViewModel)
    cell.selectionStyle = .none
    return cell
  }
}

extension MainViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let habit = viewModel.habitViewModels.value[indexPath.row]
    performSegue(withIdentifier: "SegueToDetail", sender: habit)
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in

      let popup = PopupDialog(
        title: "Delete Habit?",
        message: "確定要刪除習慣嗎？"
      )
      let containerAppearance = PopupDialogContainerView.appearance()

      let buttonOne = DestructiveButton(title: "Delete") {
        HabitManager.shared.deleteHabit(habit: self.viewModel.habitViewModels.value[indexPath.row].habit)
          self.viewModel.habitViewModels.value.remove(at: indexPath.row)
          tableView.deleteRows(at: [indexPath], with: .fade)
      }

      let buttonTwo = CancelButton(title: "Cancel") {
      }

      popup.addButtons([buttonOne, buttonTwo])
      popup.transitionStyle = .zoomIn
      containerAppearance.cornerRadius = 10

      // Present dialog
      self.present(popup, animated: true, completion: nil)

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

extension MainViewController: AchievementsCheckerDelegate {
  func showPopupView(title: String, message: String, image: String) {
    // set popView
    blurView.alpha = 0.4
    popupView.layer.cornerRadius = 20
    popupView.frame.size = CGSize(width: view.frame.width * 0.9, height: popupImage.frame.height + 220)
    popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    popupView.center = view.center
    closeButton.layer.cornerRadius = closeButton.frame.width / 2

    UIView.animate(withDuration: 0.3,
                   delay: 0,
                   usingSpringWithDamping: 0.7,
                   initialSpringVelocity: 0.7,
                   options: .curveLinear) {
      self.popupView.transform = .identity
    } completion: { _ in
      self.popupView.shake()
    }
    popupTitleLabel.text = title
    popupMessageLabel.text = message
    popupImage.image = UIImage(named: image)

    view.addSubview(blurView)
    view.addSubview(popupView)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    if touch?.view == blurView {
      blurView.removeFromSuperview()
      popupView.removeFromSuperview()
    }
  }


}
