//
//  CalendarPageViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit
import FSCalendar
import Localize_Swift

class CalendarPageViewController: UIViewController {

  @IBOutlet var popupView: UIView!
  @IBOutlet weak var popupImage: UIImageView!
  @IBOutlet weak var popupTitleLabel: UILabel!
  @IBOutlet weak var popupMessageLabel: UILabel!
  @IBOutlet weak var closeButton: UIButton!

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var calendar: FSCalendar!
  @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

  lazy var blurView: UIView = {
    let blurView = UIView(frame: view.frame)
    blurView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    return blurView
  }()

  let viewModel = HomeViewModel()
  var chosenDay = Date()
  var dailyHabitsCount: [Int: String] = [:] {
    didSet {
      calendar.reloadData()
    }
  }

  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyyMMdd"
    return formatter
  }()

  private lazy var scopeGesture: UIPanGestureRecognizer = {
    [unowned self] in
    let panGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)))
    panGesture.delegate = self
    panGesture.minimumNumberOfTouches = 1
    panGesture.maximumNumberOfTouches = 2
    return panGesture
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.backButtonTitle = ""
    self.navigationItem.title = "月曆".localized()

    NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

    AchievementsChecker.checker.delegate = self

    viewModel.refreshView = { [weak self] () in
      DispatchQueue.main.async {
        self?.tableView.reloadData()
      }
    }
    viewModel.habitViewModels.bind { [weak self] habits in
      self?.viewModel.onRefresh()
    }

    viewModel.fetchData()

    tableView.register(UINib(nibName: K.mainPageTableViewCell, bundle: nil), forCellReuseIdentifier: K.mainPageTableViewCell)

    view.addGestureRecognizer(scopeGesture)
    tableView.panGestureRecognizer.require(toFail: scopeGesture)
    setupCalendar()

    for i in 1...7 {
      HabitManager.shared.db
        .collection("habits")
        .whereField("members", arrayContains: UserManager.shared.currentUser)
        .whereField("weekday.\(i)", isEqualTo: true)
        .getDocuments { querySnapshot, error in
          if let habits = querySnapshot?.documents {
            self.dailyHabitsCount[i] = String(habits.count)
          }
        }
    }
  }

  @objc func setText() {
    navigationItem.title = "月曆".localized()
  }

  func setupCalendar() {
    calendar.select(Date())
    calendar.today = nil
    calendar.scope = .month
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.appearance.headerDateFormat = "yyyy-MM"
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let controller = segue.destination as? HabitDetailViewController
    if segue.identifier == "SegueToDetail" {
      controller?.habit = sender as? HabitViewModel
    }
  }

  @IBAction func pressCloseButton(_ sender: UIButton) {
    blurView.removeFromSuperview()
    popupView.removeFromSuperview()
  }
}

// MARK: - UITableViewDataSource
extension CalendarPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.habitViewModels.value.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.mainPageTableViewCell, for: indexPath) as! MainPageTableViewCell
    let cellViewModel = viewModel.habitViewModels.value[indexPath.row]
    cell.setup(with: cellViewModel, date: chosenDay)
    cell.selectionStyle = .none
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CalendarPageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let habit = viewModel.habitViewModels.value[indexPath.row]
    performSegue(withIdentifier: "SegueToDetail", sender: habit)
  }
}

// MARK: - UIGestureRecognizerDelegate
extension CalendarPageViewController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
    if shouldBegin {
      let velocity = self.scopeGesture.velocity(in: self.view)
      switch self.calendar.scope {
      case .month:
        return velocity.y < 0
      case .week:
        return velocity.y > 0
      @unknown default:
        fatalError("unknown case")
      }
    }
    return shouldBegin
  }

  func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    self.calendarHeightConstraint.constant = bounds.height
    self.view.layoutIfNeeded()
  }

}

// MARK: - FSCalendarDelegate and DataSource
extension CalendarPageViewController: FSCalendarDelegate {

  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

    chosenDay = date
    viewModel.fetchData(weekday: date)

    if monthPosition == .next || monthPosition == .previous {
      calendar.setCurrentPage(date, animated: true)
    }
  }

//  func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//    if date > Date() {
//      print(123)
//      return false
//    } else {
//      return true
//    }
//
//  }
//  // 本月開始日期
//  func startOfCurrentMonth() -> Date {
//    let date = Date()
//    let calendar = NSCalendar.current
//    let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: date)
//    let startOfMonth = calendar.date(from: components)!
//    return startOfMonth
//  }
//
//  // 本月结束日期
//  func endOfCurrentMonth(returnEndTime: Bool = false) -> Date {
//    let calendar = NSCalendar.current
//    var components = DateComponents()
//    components.month = 1
//    if returnEndTime {
//      components.second = -1
//    } else {
//      components.day = -1
//    }
//
//    let endOfMonth = calendar.date(byAdding: components, to: startOfCurrentMonth())!
//    return endOfMonth
//  }

  func maximumDate(for calendar: FSCalendar) -> Date {
    Date()
  }
  func minimumDate(for calendar: FSCalendar) -> Date {
    dateFormatter.date(from: UserManager.shared.userSignUpDate) ?? Date()
  }
}

extension CalendarPageViewController: FSCalendarDataSource {

  func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
    let weekday = Calendar.current.component(.weekday, from: date)
    if dailyHabitsCount.count < 7 {
      return ""
    } else {
      return dailyHabitsCount[weekday]
    }
  }
}

extension CalendarPageViewController: AchievementsCheckerDelegate {
  func showPopupView(title: String, message: String, image: String) {
    // set popView
    blurView.alpha = 0.4
    popupView.layer.cornerRadius = 20
    popupView.frame.size = CGSize(width: view.frame.width * 0.9, height: popupImage.frame.height + 220)
    popupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    popupView.center = view.center
    closeButton.layer.cornerRadius = closeButton.frame.width / 2

    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 0.7,
      initialSpringVelocity: 0.7,
      options: .curveLinear
    ) {
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
