//
//  PublicHabitsViewController.swift
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

    // set pull to refresh
    let header = MJRefreshNormalHeader()
    tableView.mj_header = header
    header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))

    viewModel.publicHabits.bind { [unowned self] habits in
      self.searchHabitsArray = habits
    }

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

    tableView.register(
      UINib(nibName: K.publicHabitsTableViewCell, bundle: nil),
      forCellReuseIdentifier: "\(PublicHabitsTableViewCell.self)"
    )

    searchBar.delegate = self
    setupSearchBar()
    setupButton()
    setPinterestSegment()
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
    var style = PinterestSegmentStyle()
    style.indicatorColor = UserManager.shared.themeColor
    style.titleMargin = 6
    style.titlePendingHorizontal = 14
    style.titlePendingVertical = 14
    style.titleFont = UIFont.boldSystemFont(ofSize: 14)
    style.normalTitleColor = .gray
    style.selectedTitleColor = .white

    segment = PinterestSegment(
      frame: CGRect(x: 0, y: 5, width: view.frame.width, height: 40),
      segmentStyle: style,
      titles: MyArray.publicHabitsPageTag.map { $0.localized() }
    )
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

  func setupSearchBar() {
    searchBar.backgroundImage = UIImage()
    searchBar.barTintColor = .systemGray6
    searchBar.searchTextField.backgroundColor = .white
    searchBar.layer.borderColor = UIColor.systemGray6.cgColor
  }


  @IBAction func pressTypeButton(_ sender: UIButton) {
    CM.items = MyArray.typeArray.map { $0.localized() }
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
    buttonTitle = sender.titleLabel?.text ?? ""
  }
  @IBAction func pressWeekdayButton(_ sender: UIButton) {
    CM.items = MyArray.weekdayArray.map { $0.localized() }
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
    buttonTitle = sender.titleLabel?.text ?? ""
  }
  @IBAction func pressLocationButton(_ sender: UIButton) {
    CM.items = MyArray.locationArray.map { $0.localized() }
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
    buttonTitle = sender.titleLabel?.text ?? ""
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let controller = segue.destination as? PublicHabitDetailViewController
    if segue.identifier == MySegue.toPublicHabitDetailPage {
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
  }

  func contextMenuDidDisappear(_ contextMenu: ContextMenu) {
  }
}

extension PublichHabitsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    searchHabitsArray.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: PublicHabitsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
    cell.setup(with: searchHabitsArray[indexPath.row])
    cell.viewController = self
    return cell
  }
}

extension PublichHabitsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let habit = searchHabitsArray[indexPath.row]
    performSegue(withIdentifier: MySegue.toPublicHabitDetailPage, sender: habit)
  }
}

extension PublichHabitsViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let searchResult = viewModel.publicHabits.value.filter { habit in
      return habit.title.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
    }
    searchHabitsArray = searchText.isEmpty ? viewModel.publicHabits.value : searchResult
  }

  func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
}
