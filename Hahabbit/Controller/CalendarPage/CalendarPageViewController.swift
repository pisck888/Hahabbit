//
//  CalendarPageViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit
import FSCalendar

class CalendarPageViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var calendar: FSCalendar!
  @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

  private lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
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
    tableView.register(UINib(nibName: K.mainPageTableViewCell, bundle: nil), forCellReuseIdentifier: K.mainPageTableViewCell)

    view.addGestureRecognizer(scopeGesture)
    tableView.panGestureRecognizer.require(toFail: scopeGesture)
    setupCalendar()
  }

  func setupCalendar() {
    calendar.scope = .month
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.appearance.headerDateFormat = "yyyy-MM"
  }
}

// MARK: - UITableViewDataSource
extension CalendarPageViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    MockData.goals.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.mainPageTableViewCell, for: indexPath) as! MainPageTableViewCell
    cell.backView.backgroundColor = MockData.colors[indexPath.row]
    cell.titleLabel.text = MockData.goals[indexPath.row]
    cell.selectionStyle = .none
    return cell
  }
}

// MARK: - UITableViewDelegate
extension CalendarPageViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "SegueToDetail", sender: nil)
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

  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    print("did select date \(self.dateFormatter.string(from: date))")
    let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
    print("selected dates is \(selectedDates)")
    if monthPosition == .next || monthPosition == .previous {
      calendar.setCurrentPage(date, animated: true)
    }
  }

  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    print("\(self.dateFormatter.string(from: calendar.currentPage))")
  }
}

extension CalendarPageViewController: FSCalendarDelegate {
}

extension CalendarPageViewController: FSCalendarDataSource {
}
