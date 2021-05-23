//
//  GoalDetailViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit
import ScrollableGraphView
import FSCalendar
import MBCircularProgressBar

class HabitDetailViewController: UITableViewController {

  @IBOutlet weak var detailView: UIView!
  @IBOutlet weak var chartViewOne: UIView!
  @IBOutlet weak var chartViewTwo: UIView!
  @IBOutlet weak var chartViewThree: UIView!

  @IBOutlet weak var calendar: FSCalendar!
  @IBOutlet weak var graphView: ScrollableGraphView!
  @IBOutlet weak var monthCircularProgressView: MBCircularProgressBarView!
  @IBOutlet weak var yearCircularProgressView: MBCircularProgressBarView!

  @IBOutlet weak var monthCircularBackView: UIView!
  @IBOutlet weak var yearCircularBackView: UIView!
  @IBOutlet weak var monthCounterView: UIView!
  @IBOutlet weak var totalCounterView: UIView!
  @IBOutlet weak var maxConsecutiveView: UIView!

  @IBOutlet weak var monthCounterLabel: UILabel!
  @IBOutlet weak var totalCounterLabel: UILabel!
  @IBOutlet weak var maxConsecutiveLabel: UILabel!

  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var sloganLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!

  @IBOutlet var weekdayButtons: [UIButton]!

  var habit: HabitViewModel?
  let dateFormatter = DateFormatter()
  let viewModel = GraphViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.monthRecord.bind { [unowned self] in
      self.monthCounterLabel.text = String($0)+"天"
    }
    viewModel.totalRecord.bind { [unowned self] in
      self.totalCounterLabel.text = String($0)+"天"
    }
    viewModel.consecutiveRecord.bind { [unowned self] in
      self.maxConsecutiveLabel.text = String($0)+"天"
    }

    graphView.dataSource = self
    setupHabitDetail()
    setupGraphView()
    setupCalendar()
    setupViews()
    setupRecordLabel()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    DispatchQueue.main.async {
      UIView.animate(withDuration: 5, delay: 0, options: .curveLinear) {
        self.monthCircularProgressView.value = 50
      }
    }
  }

  func setupViews() {
    detailView.layer.cornerRadius = 10
    chartViewOne.layer.cornerRadius = 10
    chartViewTwo.layer.cornerRadius = 10
    chartViewThree.layer.cornerRadius = 10
    calendar.layer.cornerRadius = 10
    graphView.layer.cornerRadius = 10
    monthCircularBackView.layer.cornerRadius = 10
    yearCircularBackView.layer.cornerRadius = 10
    monthCounterView.layer.cornerRadius = 10
    totalCounterView.layer.cornerRadius = 10
    maxConsecutiveView.layer.cornerRadius = 10
  }

  func setupGraphView() {
    viewModel.fetchGraphData(graphView: graphView, habitID: habit?.id ?? "")

    let linePlot = LinePlot(identifier: "line")
    let dotPlot = DotPlot(identifier: "darkLineDot")
    let referenceLines = ReferenceLines()

    linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
    linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

    dotPlot.dataPointSize = 3
    dotPlot.dataPointFillColor = .black

    referenceLines.positionType = .absolute
    // Reference lines will be shown at these values on the y-axis.
    referenceLines.absolutePositions = [0, 4, 8, 12, 16, 20, 24, 28, 31]
    referenceLines.includeMinMax = false

    graphView.dataPointSpacing = 30
    graphView.shouldAnimateOnStartup = true
    graphView.shouldAdaptRange = true
    graphView.shouldRangeAlwaysStartAtZero = true

    graphView.addPlot(plot: linePlot)
    graphView.addPlot(plot: dotPlot)
    graphView.addReferenceLines(referenceLines: referenceLines)
  }

  func setupCalendar() {
    guard let habit = habit else { return }
    calendar.allowsMultipleSelection = true
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.appearance.headerDateFormat = "yyyy-MM"

    dateFormatter.dateFormat = "yyyyMMdd"

    HabitManager.shared.db
      .collection("habits")
      .document(habit.id)
      .collection("isDone")
      .document(HabitManager.shared.currentUser)
      .getDocument { documentSnapshot, error in
        guard error == nil else {
          print(error)
          return
        }
        guard let keys = documentSnapshot?.data()?.keys else { return }
        for key in keys {
          if documentSnapshot?.data()?[key] as! Bool == true {
            self.calendar.select(self.dateFormatter.date(from: key))
          }
        }
        self.calendar.allowsSelection = false
        self.calendar.setCurrentPage(Date(), animated: true)
      }
  }

  func setupHabitDetail() {
    titleLabel.text = habit?.title
    sloganLabel.text = habit?.slogan
    detailLabel.text = habit?.detail
    for i in 0...6 {
      guard let staus = habit?.weekday["\(i + 1)"] else { return }
      weekdayButtons[i].isSelected = staus
    }
  }

  func setupRecordLabel() {
    viewModel.fetchRecordData(habitID: habit?.id ?? "")
  }
}

extension HabitDetailViewController: ScrollableGraphViewDataSource {
  func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
    // Return the data for each plot.
    switch plot.identifier {
    case "line":
      return Double(viewModel.counter[pointIndex])
    case "darkLineDot":
      return Double(viewModel.counter[pointIndex])
    default:
      return 0
    }
  }
  func label(atIndex pointIndex: Int) -> String {
    return "\(pointIndex + 1)月"
  }
  func numberOfPoints() -> Int {
    return viewModel.counter.count
  }
}

extension HabitDetailViewController: FSCalendarDataSource {
  func maximumDate(for calendar: FSCalendar) -> Date {
    Date()
  }
}

