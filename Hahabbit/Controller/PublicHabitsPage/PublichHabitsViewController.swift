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

    viewModel.publicHabits.bind { habits in
      self.searchHabitsArray = habits
      self.tableView.reloadData()
    }

    viewModel.fetchData()

    NotificationCenter.default.addObserver(self, selector: #selector(setText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)

    searchBar.delegate = self

    tableView.register(UINib(nibName: K.publicGoalsTableViewCell, bundle: nil), forCellReuseIdentifier: K.publicGoalsTableViewCell)

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

  @objc func setText() {
    navigationItem.title = "公開習慣".localized()
    setupButton()
    segment.titles = MyArray.publicHabitsPageTag.map { $0.localized() }
  }

  func setPinterestSegment() {
    style.indicatorColor = .darkGray
    style.titleMargin = 16
    style.titlePendingHorizontal = 14
    style.titlePendingVertical = 14
    style.titleFont = UIFont.boldSystemFont(ofSize: 14)
    style.normalTitleColor = .darkGray
    style.selectedTitleColor = .white
  }

  func setupButton() {
    locationButton.layer.cornerRadius = 10
    locationButton.setTitle("地區".localized(), for: .normal)
    weekdayButton.layer.cornerRadius = 10
    weekdayButton.setTitle("星期".localized(), for: .normal)
    typeButton.layer.cornerRadius = 10
    typeButton.setTitle("種類".localized(), for: .normal)
  }


  @IBAction func pressTypeButton(_ sender: UIButton) {
    CM.items = MyArray.typeArray
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
    buttonTitle = sender.titleLabel?.text ?? ""
  }
  @IBAction func pressWeekdayButton(_ sender: UIButton) {
    CM.items = MyArray.weekdayArray
    CM.showMenu(viewTargeted: sender, delegate: self, animated: true)
    buttonTitle = sender.titleLabel?.text ?? ""
  }
  @IBAction func pressLocationButton(_ sender: UIButton) {
    CM.items = MyArray.locationArray
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
    let cell = tableView.dequeueReusableCell(withIdentifier: K.publicGoalsTableViewCell, for: indexPath) as! PublicGoalsTableViewCell
    cell.setup(with: searchHabitsArray[indexPath.row])
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
