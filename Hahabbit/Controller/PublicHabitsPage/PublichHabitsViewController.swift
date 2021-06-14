//
//  PublicGoalsViewController.swift
//  Hahabbit
//
//  Created by TSAI TSUNG-HAN on 2021/5/17.
//

import UIKit
import ContextMenuSwift
import PinterestSegment
import IQKeyboardManagerSwift
import Localize_Swift
import MJRefresh

class PublichHabitsViewController: UIViewController {

  @IBOutlet weak var locationButton: UIButton!
  @IBOutlet weak var weekdayButton: UIButton!
  @IBOutlet weak var typeButton: UIButton!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentView: UIView!

  var style = PinterestSegmentStyle()
  var segment = PinterestSegment()
  let viewModel = PublicHabitViewModel()
  var buttonTitle = ""
  var searchHabitsArray: [Habit] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.backButtonTitle = ""
    navigationItem.title = "公開習慣".localized()

    searchBar.backgroundImage = UIImage()
    searchBar.barTintColor = .systemGray6
    searchBar.searchTextField.backgroundColor = .white
    searchBar.layer.borderColor = UIColor.systemGray6.cgColor

    // set pull to refresh
    let header = MJRefreshNormalHeader()
    tableView.mj_header = header
    header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))

    viewModel.publicHabits.bind { habits in
      self.searchHabitsArray = habits
    }

    NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(setThemeColor), name: NSNotification.Name("ChangeThemeColor"), object: nil)

    searchBar.delegate = self

    tableView.register(UINib(nibName: K.publicHabitsTableViewCell, bundle: nil), forCellReuseIdentifier: K.publicHabitsTableViewCell)

    setupButton()
    setPinterestSegment()
    segment = PinterestSegment(frame: CGRect(x: 0, y: 5, width: view.frame.width, height: 40), segmentStyle: style, titles: MyArray.publicHabitsPageTag.map { $0.localized() })
    segmentView.addSubview(segment)
    segment.valueChange = { index in
      switch index {
      case 0:
        self.searchHabitsArray = self.viewModel.publicHabits.value
      default:
        self.searchByTagTitle(title: MyArray.publicHabitsPageTag.map { $0.localized() }[index])
      }
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    viewModel.fetchData()
  }

  @objc func headerRefresh() {
    viewModel.fetchData()
    tableView.mj_header?.endRefreshing()
  }

  @objc func setText() {
    navigationItem.title = "公開習慣".localized()
    setupButton()
    segment.titles = MyArray.publicHabitsPageTag.map { $0.localized() }
  }

  @objc func setThemeColor() {
    segment.style.indicatorColor = UserManager.shared.themeColor
  }

  func setPinterestSegment() {
    style.indicatorColor = UserManager.shared.themeColor
    style.titleMargin = 16
    style.titlePendingHorizontal = 14
    style.titlePendingVertical = 14
    style.titleFont = UIFont.boldSystemFont(ofSize: 14)
    style.normalTitleColor = .gray
    style.selectedTitleColor = .white
  }

  func setupButton() {
    locationButton.layer.cornerRadius = 10
    locationButton.theme_backgroundColor = ThemeColor.color
    locationButton.setTitle("地區".localized(), for: .normal)
    weekdayButton.layer.cornerRadius = 10
    weekdayButton.theme_backgroundColor = ThemeColor.color
    weekdayButton.setTitle("星期".localized(), for: .normal)
    typeButton.layer.cornerRadius = 10
    typeButton.theme_backgroundColor = ThemeColor.color
    typeButton.setTitle("種類".localized(), for: .normal)
  }


  @IBAction func pressTypeButton(_ sender: UIButton) {
    CM.items = MyArray.typeArray.map{ $0.localized() }
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
    buttonTitle = sender.titleLabel?.text ?? ""
  }
  @IBAction func pressWeekdayButton(_ sender: UIButton) {
    CM.items = MyArray.weekdayArray.map{ $0.localized() }
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
    buttonTitle = sender.titleLabel?.text ?? ""
  }
  @IBAction func pressLocationButton(_ sender: UIButton) {
    CM.items = MyArray.locationArray.map{ $0.localized() }
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
    buttonTitle = sender.titleLabel?.text ?? ""
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let controller = segue.destination as? PublicHabitDetailViewController
    if segue.identifier == "SegueToPublicHabitDetail" {
      controller?.habit = sender as? Habit
    }
  }

  func searchByTagTitle(title: String) {
    searchHabitsArray = viewModel.publicHabits.value.filter { habit in
      return habit.title.range(of: title, options: .caseInsensitive, range: nil, locale: nil) != nil
    }
  }
}

extension PublichHabitsViewController: ContextMenuDelegate {
  func contextMenuDidSelect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) -> Bool {

    switch buttonTitle {
    case "地區".localized():
      if item.title == "不限制" {
        viewModel.fetchData()
      } else {
        viewModel.fetchData(withLocation: item.title)
      }
    case "星期".localized():
      viewModel.fetchData(withWeekday: (index + 1))
    case "種類".localized():
      viewModel.fetchData(withType: (index + 3))
    default:
      print("no such title")
    }
    return true
  }

  func contextMenuDidDeselect(_ contextMenu: ContextMenu, cell: ContextMenuCell, targetedView: UIView, didSelect item: ContextMenuItem, forRowAt index: Int) {
  }

  func contextMenuDidAppear(_ contextMenu: ContextMenu) {
    //    print("contextMenuDidAppear")
  }

  func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
    //    print("contextMenuDidDisappear")
  }
}

extension PublichHabitsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    searchHabitsArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: K.publicHabitsTableViewCell, for: indexPath) as! PublicHabitsTableViewCell
    cell.setup(with: searchHabitsArray[indexPath.row])
    cell.viewController = self
    cell.selectionStyle = .none
    return cell
  }
}

extension PublichHabitsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let habit = searchHabitsArray[indexPath.row]
    performSegue(withIdentifier: "SegueToPublicHabitDetail", sender: habit)
  }
}

extension PublichHabitsViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    print(searchText)
    searchHabitsArray = searchText.isEmpty ? viewModel.publicHabits.value : viewModel.publicHabits.value.filter { habit in
      return habit.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
    }
  }

  func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
}
