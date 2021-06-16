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
import Kingfisher
import Localize_Swift

class HabitDetailViewController: UITableViewController {

  @IBOutlet weak var detailView: UIView!
  @IBOutlet weak var chartViewOne: UIView!
  @IBOutlet weak var chartViewTwo: UIView!
  @IBOutlet weak var chartViewThree: UIView!

  @IBOutlet weak var chartOneTitle: UILabel!
  @IBOutlet weak var chartTwoTitle: UILabel!
  @IBOutlet weak var chartThreeTitle: UILabel!
  @IBOutlet weak var chartFourTitle: UILabel!
  @IBOutlet weak var recordOneTitle: UILabel!
  @IBOutlet weak var recordTwoTitle: UILabel!
  @IBOutlet weak var recordThreeTitle: UILabel!

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

  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var iconImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var sloganLabel: UILabel!
  @IBOutlet weak var detailLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var membersCountLabel: UILabel!

  @IBOutlet var weekdayButtons: [UIButton]!
  @IBOutlet weak var chatRoomButton: UIBarButtonItem!
  @IBOutlet weak var editButton: UIButton!

  var habit: HabitViewModel?
  let dateFormatter = DateFormatter()
  let viewModel = GraphViewModel()

  let linePlot = LinePlot(identifier: "line")
  let dotPlot = DotPlot(identifier: "dot")
  let referenceLines = ReferenceLines()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "習慣細節".localized()
    navigationItem.backButtonTitle = ""

    viewModel.monthRecord.bind { [unowned self] in
      self.monthCounterLabel.text = String($0) + "天".localized()
    }
    viewModel.totalRecord.bind { [unowned self] in
      self.totalCounterLabel.text = String($0) + "天".localized()
    }
    viewModel.consecutiveRecord.bind { [unowned self] in
      self.maxConsecutiveLabel.text = String($0) + "天".localized()
    }

    viewModel.monthPercentage.bind { percentage in
      DispatchQueue.main.async {
        self.monthCircularProgressView.value = percentage
      }
    }

    viewModel.yearPercentage.bind { percentage in
      DispatchQueue.main.async {
        self.yearCircularProgressView.value = percentage
      }
    }

    NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(setThemeColor), name: NSNotification.Name("ChangeThemeColor"), object: nil)

    graphView.dataSource = self
    setupHabitDetail()
    setupGraphView()
    setupProgressView()
    setupCalendar()
    setupViews()
    setupRecordLabel()
    setLabelString()
  }

  @objc func setText() {
    navigationItem.title = "習慣細節".localized()
    setupCalendarLanguage()
    setupRecordLabel()
    setLabelString()
  }

  @objc func setThemeColor() {
    setCalendarColor()
    setupGraphView()
    setupProgressView()
  }

  func setLabelString() {
    chartOneTitle.text = "每月完成概況".localized()
    chartOneTitle.adjustsFontSizeToFitWidth = true
    chartTwoTitle.text = "每月完成次數統計".localized()
    chartTwoTitle.adjustsFontSizeToFitWidth = true
    chartThreeTitle.text = "本月達成率".localized()
    chartThreeTitle.adjustsFontSizeToFitWidth = true
    chartFourTitle.text = "本年達成率".localized()
    chartFourTitle.adjustsFontSizeToFitWidth = true
    recordOneTitle.text = "本月完成".localized()
    recordOneTitle.adjustsFontSizeToFitWidth = true
    recordTwoTitle.text = "總共完成".localized()
    recordTwoTitle.adjustsFontSizeToFitWidth = true
    recordThreeTitle.text = "最長持續".localized()
    recordThreeTitle.adjustsFontSizeToFitWidth = true
  }

  func setupViews() {
    mainImage.layer.cornerRadius = 10
    setShadowAndCornerRadius(view: detailView)

    calendar.layer.cornerRadius = 10
    setShadowAndCornerRadius(view: chartViewOne)

    graphView.layer.cornerRadius = 10
    setShadowAndCornerRadius(view: chartViewTwo)

    setShadowAndCornerRadius(view: monthCircularBackView)
    setShadowAndCornerRadius(view: yearCircularBackView)
    setShadowAndCornerRadius(view: monthCounterView)
    setShadowAndCornerRadius(view: totalCounterView)
    setShadowAndCornerRadius(view: maxConsecutiveView)
  }

  func setupGraphView() {
    viewModel.fetchGraphData(graphView: graphView, habitID: habit?.id ?? "")

    linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
    linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
    linePlot.shouldFill = true
    linePlot.fillType = ScrollableGraphViewFillType.gradient
    linePlot.fillGradientType = ScrollableGraphViewGradientType.radial
    linePlot.lineColor = UserManager.shared.themeColor
    linePlot.fillGradientStartColor = UserManager.shared.themeColor
    linePlot.fillGradientEndColor = .white

    dotPlot.dataPointSize = 3
    dotPlot.dataPointFillColor = UserManager.shared.themeColor

    referenceLines.positionType = .absolute
    referenceLines.absolutePositions = [0, 4, 8, 12, 16, 20, 24, 28, 31]
    referenceLines.referenceLineColor = .systemGray
    referenceLines.includeMinMax = true

    graphView.dataPointSpacing = 35
    graphView.shouldAnimateOnStartup = true
    graphView.shouldAdaptRange = true
    graphView.shouldRangeAlwaysStartAtZero = true

    graphView.addPlot(plot: linePlot)
    graphView.addPlot(plot: dotPlot)
    graphView.addReferenceLines(referenceLines: referenceLines)
  }

  func setupProgressView() {
    let themeColor = UserManager.shared.themeColor
    monthCircularProgressView.progressColor = themeColor
    monthCircularProgressView.progressStrokeColor = themeColor
    monthCircularProgressView.emptyLineColor = themeColor.withAlphaComponent(0.3)
    monthCircularProgressView.emptyLineStrokeColor = themeColor.withAlphaComponent(0.3)
    yearCircularProgressView.progressColor = themeColor
    yearCircularProgressView.progressStrokeColor = themeColor
    yearCircularProgressView.emptyLineColor = themeColor.withAlphaComponent(0.3)
    yearCircularProgressView.emptyLineStrokeColor = themeColor.withAlphaComponent(0.3)
  }

  func setupCalendar() {
    guard let habit = habit else { return }
    calendar.today = nil
    calendar.allowsMultipleSelection = true
    calendar.appearance.headerMinimumDissolvedAlpha = 0.0
    calendar.appearance.headerDateFormat = "yyyy-MM"
    setupCalendarLanguage()
    setCalendarColor()

    dateFormatter.dateFormat = "yyyyMMdd"

    HabitManager.shared.db
      .collection("habits")
      .document(habit.id)
      .collection("isDone")
      .document(UserManager.shared.currentUser)
      .getDocument { documentSnapshot, error in
        guard error == nil else {
          print(error as Any)
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

  func setupCalendarLanguage() {
    if navigationItem.title == "習慣細節" {
      calendar.locale = Locale(identifier: "zh-CN")
    } else {
      calendar.locale = Locale(identifier: "en")
    }
  }

  func setCalendarColor() {
    calendar.appearance.selectionColor = UserManager.shared.themeColor
    calendar.appearance.weekdayTextColor = UserManager.shared.themeColor
    calendar.appearance.headerTitleColor = UserManager.shared.themeColor
    calendar.reloadData()
  }

  func setupHabitDetail() {
    if let habit = habit {
      let url = URL(string: habit.photo)
      mainImage.kf.setImage(with: url)
      iconImage.image = UIImage(named: habit.icon)
      titleLabel.text = habit.title
      sloganLabel.text = habit.slogan
      detailLabel.text = habit.detail
      membersCountLabel.text = "\(habit.membersCount)人已加入"
      locationLabel.text = "地點：" + habit.location
      for i in 0...6 {
        guard let staus = habit.weekday["\(i + 1)"] else { return }
        weekdayButtons[i].isSelected = staus
        weekdayButtons[i].theme_tintColor = ThemeColor.color
      }
      if habit.type["1"] == false {
        chatRoomButton.isEnabled = false
        chatRoomButton.tintColor = .clear
      } else {
        chatRoomButton.isEnabled = true
        chatRoomButton.theme_tintColor = ThemeColor.color
      }
      if habit.owner == UserManager.shared.currentUser {
        editButton.isHidden = false
      } else {
        editButton.isHidden = true
      }
    }

  }

  func setupRecordLabel() {
    viewModel.fetchRecordData(habitID: habit?.id ?? "")
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    switch segue.identifier {
    case MySegue.toAddNewGoalDetailPage:
      let viewController = segue.destination as? AddNewHabitDetailViewController
      viewController?.editHabit = habit?.habit
      viewController?.isPlusLabelHidden = true
      viewController?.delegate = self
    case MySegue.toChatRoomPage:
      let viewController = segue.destination as? ChatPageViewController
      viewController?.habitID = habit?.id
      viewController?.members = habit?.members
    default:
      print("error")
    }
  }

  func setShadowAndCornerRadius(view: UIView) {
    view.layer.shadowOffset = CGSize(width: 2, height: 2)
    view.layer.shadowOpacity = 0.5
    view.layer.shadowRadius = 2
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.cornerRadius = 10
  }

  @IBAction func pressEditButton(_ sender: UIButton) {
    performSegue(withIdentifier: MySegue.toAddNewGoalDetailPage, sender: habit)
  }

}

extension HabitDetailViewController: ScrollableGraphViewDataSource {
  func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
    // Return the data for each plot.
    switch plot.identifier {
    case "line":
      return Double(viewModel.counter[pointIndex])
    case "dot":
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

extension HabitDetailViewController: AddNewHabitDetailViewControllerDelegate {
  func setNewData(data: Habit, photo: String) {
    let url = URL(string: photo)
    habit?.habit = data
    setupHabitDetail()
    mainImage.kf.setImage(with: url)
  }
}
