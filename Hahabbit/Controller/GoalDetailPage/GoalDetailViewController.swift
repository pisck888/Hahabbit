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

class GoalDetailViewController: UITableViewController {

  @IBOutlet weak var detailView: UIView!
  @IBOutlet weak var chartViewOne: UIView!
  @IBOutlet weak var chartViewTwo: UIView!
  @IBOutlet weak var chartViewThree: UIView!
  @IBOutlet weak var plannedDayView: UIView!
  @IBOutlet weak var checkedDayView: UIView!
  @IBOutlet weak var recordView: UIView!
  @IBOutlet weak var calendar: FSCalendar!
  @IBOutlet weak var circularProgressView: MBCircularProgressBarView!
  @IBOutlet weak var graphView: ScrollableGraphView!

  override func viewDidLoad() {
    super.viewDidLoad()
    graphView.dataSource = self
    setupGraphView()
    setupCalendar()
    setupViews()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    DispatchQueue.main.async {
      UIView.animate(withDuration: 5, delay: 0, options: .curveLinear) {
        self.circularProgressView.value = 50
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
    circularProgressView.layer.cornerRadius = 10
    plannedDayView.layer.cornerRadius = 10
    checkedDayView.layer.cornerRadius = 10
    recordView.layer.cornerRadius = 10
  }

  func setupGraphView() {
    let linePlot = LinePlot(identifier: "line")
    let dotPlot = DotPlot(identifier: "darkLineDot")
    let referenceLines = ReferenceLines()

    linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
    linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

    dotPlot.dataPointSize = 3
    dotPlot.dataPointFillColor = .black

    referenceLines.positionType = .absolute
    // Reference lines will be shown at these values on the y-axis.
    referenceLines.absolutePositions = [0, 5, 10, 15, 20, 25, 30]
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
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.appearance.headerDateFormat = "yyyy-MM"
  }

}

extension GoalDetailViewController: ScrollableGraphViewDataSource {
  func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
    // Return the data for each plot.
    switch plot.identifier {
    case "line":
      return Double(MockData.mockNumbers[pointIndex])
    case "darkLineDot":
      return Double(MockData.mockNumbers[pointIndex])
    default:
      return 0
    }
  }
  func label(atIndex pointIndex: Int) -> String {
    return "\(pointIndex + 1)月"
  }
  func numberOfPoints() -> Int {
    return MockData.mockNumbers.count
  }
}
